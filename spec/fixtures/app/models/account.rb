# require 'kaminari/activerecord'
require 'will_paginate/active_record'
class Account < ActiveRecord::Base
  enum status: ['deleted', 'active', 'inactive', 'archived']
end
