require 'active_record'
require 'rails_machine'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
end
