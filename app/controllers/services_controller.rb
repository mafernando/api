# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string           not null
#  uuid       :string           not null
#  name       :string           not null
#  health     :integer          default(0), not null
#  status     :integer
#  status_msg :string
#  product_id :integer
#  order_id   :integer
#
# Indexes
#
#  index_services_on_type  (type)
#  index_services_on_uuid  (uuid)
#

class ServicesController < ApplicationController
  SERVICE_INCLUDES = %w(alerts latest_alerts order project product provider product_type service_outputs logs).freeze

  after_action :verify_authorized

  api :GET, '/services', 'Returns all services'
  param :includes, Array, in: SERVICE_INCLUDES
  param :page, :number
  param :per_page, :number

  def index
    authorize Service
    respond_with_params services, index_respond_options
  end

  api :GET, '/services/:id', 'Returns a service'
  param :id, :number, required: true
  param :includes, Array, in: SERVICE_INCLUDES
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    authorize service
    respond_with_params service, serializer: ServiceSerializer
  end

  private

  def index_respond_options
    { each_serializer: ServiceSerializer, except: [:type, :uuid, :health, :status_msg, :created_at, :updated_at] }
  end

  def services
    @_services ||= query_with Service.all, :includes, :pagination
  end

  def service
    @_service = Service.find params[:id]
  end
end
