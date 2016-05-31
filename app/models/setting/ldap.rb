class Setting
  class LDAP < Setting
    def self.load_defaults
      return unless super
      transaction do
        [
          set('ldap_enabled', description: 'LDAP Enabled', value_type: :boolean, default: false),
          set('ldap_host', description: 'LDAP Host', value_type: :string, default: 'address'),
          set('ldap_port', description: 'LDAP Port', value_type: :string, default: '389'),
          set('ldap_ssl_enabled', description: 'LDAP SSL Enabled', value_type: :boolean, default: false),
          set('ldap_base_dn', description: 'LDAP Base DN', value_type: :string, default: 'value')
        ].each { |s| create! s.merge!(type: 'Setting::LDAP') }
      end
    end
  end
end
