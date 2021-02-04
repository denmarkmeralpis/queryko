# frozen_string_literal: true

module Queryko
  module Filters
    class MultiTableBatchSort < ::Queryko::Filters::Base
      def perform(collection, query_token, query_object)
        orders = []

        query_token.sort.to_h.each do |_, token|
          token.each do |table, order|
            order.each do |column, value|
              orders << "#{table}.#{column} #{value}"
            end
          end
        end

        collection.order(orders.join(','))
      end
    end
  end
end

