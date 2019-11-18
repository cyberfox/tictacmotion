$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError => e
  puts "Warning, load failure: #{e}"
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'tictac'


  app.device_family = [:iphone, :ipad]
  app.identifier = 'com.cyberfox.tictac'
  app.deployment_target = '12.0'

  app.development do
    app.codesign_certificate = MotionProvisioning.certificate(
      type: :development,
      platform: :ios)

    app.provisioning_profile = MotionProvisioning.profile(
      bundle_identifier: app.identifier,
      app_name: app.name,
      platform: :ios,
      type: :development)
  end
end
