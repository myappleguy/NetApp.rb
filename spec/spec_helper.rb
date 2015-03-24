require './lib/nmsdk/NaElement'
require './lib/nmsdk/NaServer'
require './lib/net-app-sdk/filer'
require './lib/net-app-sdk/aggregate'
require './lib/net-app-sdk/diag'
require './lib/net-app-sdk/nfs'
require './lib/net-app-sdk/qtree'
require './lib/net-app-sdk/quota'
require './lib/net-app-sdk/snapshot'
require './lib/net-app-sdk/vfiler'
require './lib/net-app-sdk/volume'
require './lib/net-app-sdk/version'

begin; require 'pry'; rescue LoadError; end

require 'rspec'

RSpec.configure do |config|
  config.before(:each) { make_test_directory }
  config.after(:each) { remove_test_directory }

  config.mock_with :rspec
end
