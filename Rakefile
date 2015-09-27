# -*- coding: utf-8 -*-
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
  app.deployment_target = '6.1'
  app.device_family = [:iphone, :ipad]
  app.identifier = 'com.cyberfox.tictac'
  app.provisioning_profile='TicTac_Profile.mobileprovision'
end
