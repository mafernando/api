# == Schema Information
#
# Table name: registered_providers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#  type       :string           not null
#  name       :string           not null
#  uuid       :string           not null
#
# Indexes
#
#  index_registered_providers_on_type  (type)
#  index_registered_providers_on_uuid  (uuid)
#

class RegisteredProvidersController < ApplicationController
  after_action :verify_authorized

  api :GET, '/registered_providers', 'Returns a list of registered providers'
  def index
    authorize RegisteredProvider
    respond_with registered_providers, each_serializer: RegisteredProviderSerializer
  end

  private

  def registered_providers
    @_reg_prov ||= query_with RegisteredProvider.all, :includes, :pagination
  end
end
