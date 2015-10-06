def run(command)
  system(command) or raise "RAKE TASK FAILED: #{command}"
end

namespace "test" do
  desc "Run unit tests for iOS"
  task :ios do |t|
    puts "runnings tests for iOS"
    run "set -o pipefail && xcodebuild -project MathKit.xcodeproj -scheme MathKitTests -destination 'platform=iOS Simulator,name=iPhone 6' test 2>/dev/null | xcpretty -c --formatter scripts/xcpretty-formatter.rb && echo 'iOS Tests Passed'"
  end

  desc "Run unit tests or osx"
  task :osx do |t|
    puts "runnings tests for osx"
    run "set -o pipefail && xcodebuild -project RSSClient.xcodeproj -scheme MathKitOSX test 2>/dev/null | xcpretty -c --formatter scripts/xcpretty-formatter.rb && echo 'OSX App tests Passed'"
  end
end

task :test => ["test:ios", "test:osx"]

task default: ["test"]


