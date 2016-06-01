class SessionsController < Devise::SessionsController
  respond_to :json, :html

  skip_before_action :require_no_authentication, :require_user, only: :create
  skip_before_action :verify_signed_out_user, only: :destroy

  api :POST, '/staff/sign_in', 'Signs user in'
  param :staff, Hash, desc: 'Staff' do
    param :email, String, required: false, desc: 'Email'
    param :username, String, required: false, desc: 'Username'
    param :password, String, required: true, desc: 'Password'
  end
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    respond_to do |format|
      format.html do
        if request.env['omniauth.auth']
          auth_hash = request.env['omniauth.auth']

          staff = Staff.find_by_auth(auth_hash)

          sign_in_and_redirect(resource_name, staff) if staff.present?
        else
          super
        end
      end
      format.json do
        self.resource = warden.authenticate(auth_options)
        if resource
          sign_in(resource_name, resource)
          api_token = ApiToken.create! staff: resource
          resource.api_token = api_token.token
          render json: resource
        else
          if Setting::LDAP[:ldap_enabled] && params.dig('staff', 'username') # get ldap info for bind user
            # get ldap uid and password from params
            ldap_uid = params.dig('staff', 'username')
            ldap_password = params.dig('staff', 'password')

            # get ldap server settings
            ldap_host = Setting::LDAP[:ldap_host]
            ldap_port = Setting::LDAP[:ldap_port].to_i
            ldap_base_dn = Setting::LDAP[:ldap_base_dn]
            ldap_bind_dn = "uid=#{ldap_uid},#{ldap_base_dn}"

            # make ldap connection
            ldap = Net::LDAP.new host: ldap_host,
                                 port: ldap_port,
                                 auth: {
                                   method: :simple,
                                   username: ldap_bind_dn,
                                   password: ldap_password
                                 }

            begin # indicate invalid login if ldap fails to bind or if no valid memberships exist
              if ldap.bind # query ldap for user info and memberships
                # todo: decouple this so it doesn't require a bind user
                filter = Net::LDAP::Filter.eq('uid', ldap_uid)

                # TODO: these may not be consistent across AD instances
                result_attrs = %w(uid givenname sn mail memberof)
                ldap_response = ldap.search(base: ldap_base_dn, filter: filter, attributes: result_attrs)

                # verify user is a member of JF groups: JF-User, JF-Manager, JF-Admin
                groups = %w(JF-User JF-Manager JF-Administrator)
                ldap_user = ldap_response[0]
                memberships = ldap_user.nil? ? [] : ldap_user[:memberof]
                user_in_group = groups.any? { |g| memberships.inject(false) { |a, e| a || e.include?(g) } }

                if user_in_group # sync ldap user
                  # find highest user role : user < manager < admin
                  user_role = Staff.roles[:user]
                  user_role = Staff.roles[:manager] if %w(JF-Manager).any? { |g| memberships.inject(false) { |a, e| a || e.include?(g) } }
                  user_role = Staff.roles[:admin] if %w(JF-Administrator).any? { |g| memberships.inject(false) { |a, e| a || e.include?(g) } }

                  # check if user in JF already exists with the ldap user email
                  resource = Staff.where(email: ldap_user[:mail]).first
                  if resource.nil?
                    # map ldap user to jf staff params
                    staff_params = {}
                    staff_params[:first_name] = ldap_user[:givenname][0]
                    staff_params[:last_name] = ldap_user[:sn][0]
                    staff_params[:email] = ldap_user[:mail][0]
                    staff_params[:phone] = nil
                    staff_params[:role] = user_role
                    staff_params[:password] = ldap_password
                    staff_params[:password_confirmation] = ldap_password

                    # create jf user for ldap user
                    resource = Staff.create staff_params
                  end
                  # sign ldap user in and set api token
                  sign_in(resource)
                  api_token = ApiToken.create! staff: resource
                  resource.api_token = api_token.token
                  render json: resource
                end
              else
                render json: { error: 'Invalid Login' }, status: 401
              end
            rescue
              render json: { error: 'Invalid Login' }, status: 401
            end
          else
            render json: { error: 'Invalid Login' }, status: 401
          end
        end
      end
    end
  end

  api :DELETE, '/staff/sign_out', 'Invalidates user session'

  def destroy
    if request.headers.key?('HTTP_AUTHORIZATION') || params[:access_token]
      token = request.headers.fetch('HTTP_AUTHORIZATION', '').split(' ').last || params[:access_token]
      if warden.user == Staff.joins(:api_tokens).find_by(api_tokens: { token: token })
        ApiToken.delete_all(token: token)
      end
    end
    respond_to do |format|
      format.html do
        super
      end
      format.json do
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        render json: {}, status: :ok
      end
    end
  end
end
