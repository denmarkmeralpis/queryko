# frozen_string_literal: true

require 'queryko/filters/base'
require 'queryko/filters/after'
require 'queryko/filters/before'
require 'queryko/filters/min'
require 'queryko/filters/max'
require 'queryko/filters/search'
require 'queryko/filters/or_search'
require 'queryko/filters/order'
require 'queryko/filters/batch'
require 'queryko/filters/paginate'
require 'queryko/filters/batch_sort'
require 'queryko/filters/modified_search'
require 'queryko/filters/multi_table_batch_sort'

module Queryko
  module FilterClasses
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        class_attribute :filters, default: {}
        load_defaults
      end
    end

    module ClassMethods
      def load_defaults
        self.filters = {
          after: 'Queryko::Filters::After',
          before: 'Queryko::Filters::Before',
          min: 'Queryko::Filters::Min',
          max: 'Queryko::Filters::Max',
          search: 'Queryko::Filters::Search',
          or_search: 'Queryko::Filters::OrSearch',
          order: 'Queryko::Filters::Order',
          batch: 'Queryko::Filters::Batch',
          paginate: 'Queryko::Filters::Paginate',
          batch_sort: 'Queryko::Filters::BatchSort',
          modified_search: 'Queryko::Filters::ModifiedSearch',
          multi_table_batch_sort: 'Queryko::Filters::MultiTableBatchSort'
        }
      end

      def filter_class(symbol, klass)
        filters[symbol.to_sym] = constantize_class(klass)
      end

      private

      def constantize_class(klass)
        return klass unless klass.class == String

        klass.constantize
      end
    end
  end
end
