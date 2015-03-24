begin; require 'pry'; rescue LoadError; end

require 'rspec'

RSpec.configure do |config|
  config.before(:each) { make_test_directory }
  config.after(:each) { remove_test_directory }

  config.mock_with :rspec
end
