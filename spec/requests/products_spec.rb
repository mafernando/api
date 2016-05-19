# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  description     :text
#  active          :boolean          default(TRUE)
#  img             :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  deleted_at      :datetime
#  setup_price     :decimal(10, 4)   default(0.0)
#  hourly_price    :decimal(10, 4)   default(0.0)
#  monthly_price   :decimal(10, 4)   default(0.0)
#  cached_tag_list :string
#  provider_id     :integer
#  product_type_id :integer
#  type            :string           default("Product"), not null
#
# Indexes
#
#  index_products_on_deleted_at       (deleted_at)
#  index_products_on_product_type_id  (product_type_id)
#  index_products_on_provider_id      (provider_id)
#

require 'rails_helper'

RSpec.describe 'Products API' do
  let(:default_params) { { format: :json } }

  describe 'GET index' do
    before(:each) do
      @product = create(:product)
      sign_in_as create :staff
      @products = Product.all
    end

    it 'returns a collection of all of the products', :show_in_doc do
      get '/api/v1/products'
      expect(json.map { |product| product['id'] }).to eq(@products.map(&:id))
    end

    it 'paginates the products' do
      get '/api/v1/products', page: 1, per_page: 1
      expect(json.length).to eq(1)
    end
  end

  describe 'GET show' do
    before(:each) do
      @product = create :product
      sign_in_as create :staff
    end

    it 'returns an product', :show_in_doc do
      get "/api/v1/products/#{@product.id}"
      expect(json['id']).to eq(@product.id)
    end

    it 'returns an error when the product does not exist' do
      get "/api/v1/products/#{@product.id + 999}"
      expect(response.status).to eq(404)
      expect(json).to eq('error' => 'Not found.')
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @product = create :product
      sign_in_as create :staff, :admin
    end

    it 'removes the product', :show_in_doc do
      delete "/api/v1/products/#{@product.id}"
      expect(response.status).to eq(204)
    end

    it 'returns an error when the product does not exist' do
      delete "/api/v1/products/#{@product.id + 999}"
      expect(response.status).to eq(404)
      expect(json).to eq('error' => 'Not found.')
    end
  end

  describe 'POST create' do
    it 'creates a product without any answers' do
      sign_in_as create :staff, :admin
      product_type = create :product_type
      product_attributes = attributes_for :product, answers: nil
      product_attributes[:product_type_id] = product_type.id

      post products_path, product_attributes

      expect(response).to be_success
    end

    it 'maps provisioning_answers to a hash' do
      sign_in_as create :staff, :admin
      answers = [
        { name: 'foo', value: 'bar', value_type: 'string' },
        { name: 'fizz', value: 'buzz', value_type: 'string' }
      ]
      product_type = create :product_type
      product_attributes = attributes_for :product, answers: answers
      product_attributes[:product_type_id] = product_type.id

      post products_path, product_attributes

      expect(response).to be_success
      expect(Product.last.answers.length).to eq 2
      expect(Product.last.answers.map(&:name)).to contain_exactly 'foo', 'fizz'
      expect(Product.last.answers.map(&:value)).to contain_exactly 'bar', 'buzz'
    end
  end
end
