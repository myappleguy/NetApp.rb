#!/usr/bin/env ruby
#
# NetApp.rb:
#   * Ruby library for NetApp filer administration via NetApp NMSDK
#   * https://github.com/azet/NetApp.rb
#
# LICENSE:
#   MIT License (http://opensource.org/licenses/MIT)
#
# AUTHORS:
#   Aaron <azet@azet.org> Zauner
#

# TODO - Is this dependent upon something that it cannot get on its own
# as a dependency ro can't be included in the gem itself ??
#
# Include NetApp Manageability SDK for Ruby (change name if neccessary)
# $: << File.expand_path(File.dirname(__FILE__) + "/../lib/NMSDK-Ruby")
require 'nmsdk/NaServer'
#require 'NaServer'

#
#  "Style is what gives value and currency to thoughts." -- Schopenhauer
#

#EOF
