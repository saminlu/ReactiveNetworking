require 'rubygems'
require 'bundler/setup'
Bundler.setup
require 'rake'

task default: 'test'

desc 'Execute iOS and Mac tests'
task :test do
  sh "xcodebuild -workspace ReactiveNetworking.xcworkspace -scheme 'ReactiveNetworking Mac' -sdk macosx -configuration Debug test | xcpretty -c"
  sh "xcodebuild -workspace ReactiveNetworking.xcworkspace -scheme 'ReactiveNetworking iOS' -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone Retina (4-inch),OS=7.0' -configuration Debug test | xcpretty -c"
end
