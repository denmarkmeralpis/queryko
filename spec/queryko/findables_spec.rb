require 'spec_helper'

RSpec.describe Queryko::Findables do
  let(:sample_class) do
    Class.new do
      include Queryko::Findables

      attr_accessor :params, :relation

      def initialize(params = {}, relation)
        @relation = relation
        @params = params
      end

      def call
        filter_by_findables
        relation
      end

      add_findables :name, :description

      def defined_table_name
         'products'
      end
    end
  end

  before do
    Product.create(description: 'Zipline')
    5.times do |i|
      Product.create(name: "Product #{i}")
    end
  end

  describe 'instance' do
    context '#findables' do
      it 'searches for keyword 3' do
        expect(sample_class.new({ keyword: '3' }, Product.all).call.count).to eq(1)
      end

      it 'searches for keyword 4' do
        expect(sample_class.new({keyword: '4'}, Product.all).call.first)
          .to eq(Product.find_by(name: 'Product 4'))
      end

      it 'searches for keyword zipline' do
        query = sample_class.new({ keyword: 'zip' }, Product.all).call

        expect(query.count).to eq(1)
        expect(query.first).to eq(Product.find_by(description: 'Zipline'))
      end
    end
  end
end