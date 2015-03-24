Gem::Specification.new do |spec|
  spec.name = 'net-app-sdk'
  spec.version = NetAppSdk::VERSION
  spec.date = '2015-03-23'
  spec.summary = 'net-app-sdk'
  spec.description = 'Ruby gem to interface with NetApp Filers (via NMSDK), used for GRC'
  spec.requirements = 'Proprietary NMSDK as provided by NetApp'
  spec.authors = ["Todd Pickell", "Marion Newman"]
  spec.email = 'todd.pickell@ge.com'
  spec.homepage = 'https://github.com/myappleguy/NetApp.rb'
  spec.license = 'MIT'

  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_dependency "rake"
end
