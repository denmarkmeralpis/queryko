require 'spec_helper'

module Queryko
  module Filters
    RSpec.describe BatchSort do
      let(:anon_query_class) do
        Class.new(::Queryko::Base) do
          feature :sort_by, :batch_sort, as: :sort_by

          table_name :products
        end
      end

      before do
        Product.create(name: 'AAA', out_of_stock: true)
        Product.create(name: 'BBB', out_of_stock: true)
        Product.create(name: 'CCC', out_of_stock: false)
        Product.create(name: 'DDD', out_of_stock: true)
        Product.create(name: 'EEE', out_of_stock: true)
      end

      context 'when using multiple sort_by' do
        let(:query) { anon_query_class.new(filter, Product.all) }
        let(:result) { query.call }
        let(:filter) do
          {
            sort_by: {
              "0": { out_of_stock: 'DESC' },
              "1": { name: 'ASC' }
            }
          }
        end

        it { expect(result.first.name).to eq('AAA') }
        it { expect(result.last.name).to eq('CCC') }
      end
    end
  end
end
