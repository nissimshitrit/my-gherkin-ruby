# frozen_string_literal: true

require "fileutils"

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
  warn "cucumber 7.0.0 is not compatible with Ruby #{RUBY_VERSION}; use Ruby < 3.4"
  exit 2
end

# Keep cucumber invocation in one place so Maven can call a single script.
report_dir = File.join("reports", "junit")
FileUtils.mkdir_p(report_dir)

# Keep gems in the workspace to avoid permission issues on CI agents.
# Jenkinsfile sets BUNDLE_PATH at the pipeline level; this is a fallback for local runs.
ENV["BUNDLE_PATH"] ||= File.join("vendor", "bundle")

# RUBYOPT may be set in the Jenkins agent environment with legacy flags (e.g. -F)
# that are not valid in Ruby 3.x. Clear it to avoid RuntimeError on startup.
ENV.delete("RUBYOPT")

# Use plain "bundle" (resolved via PATH) to avoid broken paths with spaces on Windows.
unless system("bundle", "check")
  warn "Missing gems detected; running bundle install..."
  exit(1) unless system("bundle", "install", "--jobs", "4", "--retry", "3")
end

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
