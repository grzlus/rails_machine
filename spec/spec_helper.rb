ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rails_machine'

Rails.backtrace_cleaner.remove_silencers!
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
end

