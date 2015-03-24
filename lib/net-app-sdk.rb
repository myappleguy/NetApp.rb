#!/usr/bin/env ruby
#
# net-app-sdk
#   * Ruby gem for NetApp filer administration via NetApp NMSDK
#   * https://github.com/azet/NetApp.rb
#
# LICENSE:
#   MIT License (http://opensource.org/licenses/MIT)
#
# AUTHORS:
#  Todd Pickell @tapickell <todd.pickell@ge.com>
#  Marion Newman <marion.newman@ge.com>
#
#

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

module NetAppSdk
end

