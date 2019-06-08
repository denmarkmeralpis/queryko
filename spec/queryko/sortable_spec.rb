require 'spec_helper'
require 'byebug'

RSpec.describe Queryko::Sortables do
  let(:sample_class) do
    Class.new do
      include Queryko::Sortables
      attr_accessor :params, :relation
      def initialize(params = {}, relation)
        @relation = relation
        @params = params
      end
      def call
        filter_by_sortables
        relation
      end
      add_sortables :name

      def defined_table_name
         'products'
       end
    end
  end

  describe 'anonymous class' do
    describe 'subclass' do
      let(:sample_subclass) {
        Class.new(sample_class) do
          add_sortables :name
        end
      }
      let(:query_subclass) { sample_subclass }

      it "has sortables name" do
        expect(query_subclass.sortables.first).to eq(:name)
        expect(query_subclass.sortables.last).to eq(:name)
      end
    end

    describe 'instance' do
      context '#sortables' do
        let(:query_instance) { sample_class.new nil, nil }

        it "has sortables :name" do
          expect(query_instance.sortables.first).to eq(:name)
        end

        it "doesn't override sortables" do
          expect{ query_instance.sortables = [:hello] }.to raise_error(NoMethodError)
        end
      end

      context "#filter_sortable" do
         before do
            5.times do |i|
               Product.create(name: "Sample #{i}")
            end
         end

        it "filters records by asc" do
          query = sample_class.new({ sort_by_name: 'asc' }, Product.all)
          expect(query.call.first).to eq(Product.first)
        end

        it 'filters records by desc' do
         query = sample_class.new({sort_by_name: 'desc'}, Product.all)
         expect(query.call.first).to eq(Product.last)
        end
      end
    end

    describe 'included' do
      context "with attributeless class" do
        let(:attributeless_class) {
          Class.new do
            include Queryko::Sortables
          end
        }
        it "is working well" do
          object = attributeless_class.new
          expect(object.sortables).to eq([])
        end
      end
    end
  end
end
