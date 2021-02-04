# frozen_string_literal: true

require 'queryko/filters/base'
require 'byebug'

module Queryko
  module Filters
    class BatchSort < ::Queryko::Filters::Base 
      # format should be like this:
      # ==================================
      # {
      #   "sort_by":{
      #     "0":{
      #       "seq":"asc"
      #     },
      #     "1":{
      #       "name":"desc"
      #     }
      #   }
      # }
  
      def perform(collection, query_token, _)
        tokens = []
        query_token.each { |i, val| tokens[i.to_s.to_i] = val }
        tokens = tokens.reduce({}, :merge)

        orders = []
        tokens.each do |k, v|
          orders << "#{table_name}.#{k} #{v}"
        end

        # tokens = tokens.each_with_object({}) do |(k, v1), obj|
        #   obj["#{table_name}.#{k}"] = v1
        # end
        # byebug
        # collection.order(tokens)
        #
        collection.order(orders.join(','))
      end
    end
  end
end
