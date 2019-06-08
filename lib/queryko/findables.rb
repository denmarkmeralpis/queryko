require "queryko/configuration"

module Queryko
   module Findables
      include Queryko::Configuration

      def self.included(base)
         base.extend(ClassMethods)
         base.class_eval do
            class_attribute :findables, default: Array.new, instance_writer: false
            self.findables = []

            private

            def filter_by_findables
               return true unless params[:keyword]

               query_conditions = []
               self.findables.each do |findable|
                  query_conditions << "LOWER(#{qoute}#{defined_table_name}#{qoute}.#{qoute}#{findable}#{qoute}) LIKE :keyword"
               end

               self.relation = relation.where(query_conditions.join(' OR '), keyword: "%#{params[:keyword]}%")
            end
         end
      end

      module ClassMethods
         def add_findables(*args)
            self.findables ||= []
            self.findables += args
         end
      end
   end
 end
