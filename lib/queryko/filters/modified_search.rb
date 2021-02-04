# frozen_string_literal: true

module Queryko
  module Filters
    class ModifiedSearch < ::Queryko::Filters::Search
      def initialize(options, feature)
        super(options, feature)
      end

      def perform(collection, token, query_object)
        @table_name = collection.table_name

        super(collection, token, query_object)
      end
    end
  end
end
