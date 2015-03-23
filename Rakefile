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
  app.device_family = [:iphone, :ipad]
  app.provisioning_profile = "/Users/mrs/Downloads/iOS_Team_Provisioning_Profile_.mobileprovision"
end
