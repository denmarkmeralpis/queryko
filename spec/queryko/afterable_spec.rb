require 'spec_helper'

RSpec.describe Queryko::Afterables do
  let(:sample_class) do
    Class.new do
      include Queryko::Afterables

      attr_accessor :params, :relation

      def initialize(params = {}, relation)
        @relation = relation
        @params = params
      end

      def call
        filter_by_afterables
        relation
      end

      add_afterables :id

      def defined_table_name
         'products'
      end
    end
  end

  describe 'instance' do
    context '#afterables' do
      let(:p1) { Product.create(name: 'p1') }
      let(:p2) { Product.create(name: 'p2') }
      let(:p3) { Product.create(name: 'p3') }
      let(:p4) { Product.create(name: 'p4') }
      let(:p5) { Product.create(name: 'p5') }

      before do
        p1
        p2
        p3
        p4
        p5
      end

      it 'has 3 records' do
        expect(sample_class.new({ after_id: p3.id }, Product.all).call.count)
          .to eq(2)
      end

      it 'has 0 records' do
        expect(sample_class.new({ after_id: p5.id }, Product.all).call.count)
          .to eq(0)
      end
    end
  end
end