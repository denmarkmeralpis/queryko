require 'spec_helper'

module Queryko
  module Filters
    RSpec.describe OrSearch do
      let(:fake_class) do
        Class.new(::Queryko::Base) do
          feature :keyword, :or_search, as: :keyword, cols: [:name, :sku]

          table_name :products
        end
      end

      before do
        Product.create(name: 'Aspirin', sku: 'medicine-1')
        Product.create(name: 'Medicine', sku: 'no-sku-0')
        Product.create(name: 'Alaxan', sku: 'no-sku-1')
      end

      context 'when filter :keyword' do
        let(:query) { fake_class.new(filter, Product.all) }
        let(:result) { query.call }
        let(:filter) do
          { keyword: 'medic' }
        end

        it 'contains 2 search results' do
          expect(result.count).to eq(2)
        end
      end
    end
  end
end
