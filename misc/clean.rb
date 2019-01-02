require './lib/sqlite'
require 'active_support/core_ext'

ActiveRecord::Base.subclasses.collect { |class_name|
  Object.const_get(class_name.name).send('delete_all')
}