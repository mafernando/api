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

require 'rails_helper'

RSpec.describe 'Product Types API' do
  describe 'GET index' do
    it 'returns a collection of all product types' do
      sign_in_as create(:staff, :admin)

      create :product_type
      create :product_type

      get '/api/v1/product_types'

      expect(json.length).to eq 2
    end
  end
end
