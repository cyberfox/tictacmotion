$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'tictac'
  app.device_family = [:iphone, :ipad]
  app.identifier = 'com.cyberfox.tictac'
  app.provisioning_profile 'TicTac'
#  app.target 'tictacwatch', :extension
end
