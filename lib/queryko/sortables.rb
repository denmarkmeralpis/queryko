require "queryko/configuration"

module Queryko
  module Sortables
    include Queryko::Configuration

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        class_attribute :sortables, default: Array.new, instance_writer: false
        self.sortables = []

        private

        def filter_by_sortables
          self.sortables.each do |sortable|
            column_name = sortable.to_s.gsub(/sort_by_/, '')
            order = params["sort_by_#{sortable}".to_sym].to_s.downcase == 'asc' ? 'ASC' : 'DESC'

            self.relation = relation.reorder(Arel.sql(
              "#{qoute}#{defined_table_name}#{qoute}.#{qoute}#{column_name}#{qoute} #{order}"
              )
            ) if params["sort_by_#{sortable}".to_sym]
          end
        end
      end
    end

    module ClassMethods
      def add_sortables(*args)
        self.sortables ||= []
        self.sortables += args
      end
    end
  end
end
