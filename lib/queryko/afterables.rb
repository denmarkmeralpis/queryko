module Queryko
	module Afterables
		def self.included(base)
			base.extend(ClassMethods)
			base.class_eval do
				class_attribute :afterables, default: Array.new, instance_writer: false
				self.afterables = []

				private

        def filter_by_afterables
          self.afterables.each do |afterable|
            column = afterable.to_sym

            self.relation = relation.where(
              "#{defined_table_name}.#{column} > :after",
              after: params["after_#{column}".to_sym]
            )
          end
				end
			end
		end

		module ClassMethods
			def add_afterables(*args)
				self.afterables ||= []
				self.afterables += args
			end
		end
	end
end
