# == Schema Information
#
# Table name: product_types
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  type          :string           not null
#  name          :string           not null
#  uuid          :string           not null
#  active        :boolean          default(TRUE), not null
#  provider_type :string           not null
#
# Indexes
#
#  index_product_types_on_provider_type  (provider_type)
#  index_product_types_on_type           (type)
#  index_product_types_on_uuid           (uuid)
#

class ProductTypesController < ApplicationController
  after_action :verify_authorized

  api :GET, '/product_types', 'Returns a list of all product types'

  def index
    authorize ProductType
    render json: ProductType.all, each_serializer: ProductTypeSerializer
  end

  api :GET, '/product_types/:id', 'Returns information on a product type'

  def show
    render json: product_type, serializer: ProductTypeSerializer
  end

  private

  def product_type
    @_product_type ||= ProductType.find(params[:id]).tap { |pt| authorize pt }
  end
end
