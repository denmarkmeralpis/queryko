require 'queryko/filters/base'

module Queryko
  module Filters
    class OrSearch < ::Queryko::Filters::Base
      attr_reader :cols

      def initialize(options, feature)
        @cols = options.fetch(:cols)

        super(options, feature)
      end

      def perform(collection, token, _)
        query_conditions = []

        cols.each do |column|
          query_conditions << "LOWER(#{table_name}.#{column}) LIKE :token"
        end

        collection.where(query_conditions.join(' OR '), token: "%#{token}%")
      end
    end
  end
end
