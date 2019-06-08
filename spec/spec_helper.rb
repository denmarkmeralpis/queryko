require "bundler/setup"

require 'active_record'
require "queryko"
require "fixtures/app/models/product"
require 'active_support/inflector/methods'
require 'byebug'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:each) do
    Product.delete_all
  end
end

# ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
migration_files_path = File.expand_path('../fixtures/app/migrations', __FILE__)

module Db
  # db is MySQL
  module MySQL
    def connect_db
      ActiveRecord::Base.establish_connection(db_config)
    end

    def drop_and_create_database
      temp_connection = db_config.merge(database: 'mysql')

      ActiveRecord::Base.establish_connection(temp_connection)
      # drop existing db if exists
      ActiveRecord::Base.connection.drop_database(db_name) rescue nil
      # create new db
      ActiveRecord::Base.connection.create_database(db_name)
    end

    def db_config
      @db_config ||= {
        adapter:   'mysql2',
        database:  db_name,
        username:  db_user,
        password: db_password
      }
    end

    def db_user
      ENV['TRAVIS_DB_USER'] ? 'travis' : 'root'
    end

    def db_password
      ENV['TRAVIS_DB_PASSWORD'] ? '' : 'root'
    end

    def db_name
      'dm_filter_test'
    end
  end
end

include Db::MySQL

drop_and_create_database
connect_db

if ActiveRecord.gem_version >= Gem::Version.new('5.2.2')
  ActiveRecord::MigrationContext.new(migration_files_path).migrate
else
  ActiveRecord::Migrator.migrate(migration_files_path)
end
