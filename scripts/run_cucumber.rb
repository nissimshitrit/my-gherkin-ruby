# frozen_string_literal: true

require "fileutils"

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
  warn "cucumber 7.0.0 is not compatible with Ruby #{RUBY_VERSION}; use Ruby < 3.4"
  exit 2
end

# Keep cucumber invocation in one place so Maven can call a single script.
report_dir = File.join("reports", "junit")
FileUtils.mkdir_p(report_dir)

command = [
  "bundle",
  "exec",
  "cucumber",
  "--strict",
  "--format",
  "progress",
  "--format",
  "junit",
  "--out",
  report_dir,
  "features"
]

puts "Running: #{command.join(" ")}"
puts "JUnit reports dir: #{report_dir} (files: TEST-*.xml)"
success = system(*command)
exit(success ? 0 : 1)
