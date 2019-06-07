module Queryko
   module Configuration
      # TODO: Add config for setting db adapter
      # For now, we'll use MySQL back tick(`table`.`column_name`)

      def qoute
         mysql
      end

      private

      def mysql
         "`"
      end

      def pg
         "\""
      end
   end
end