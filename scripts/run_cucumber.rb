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

# RUBYOPT may be set in the Jenkins agent/service-account environment with legacy
# flags (e.g. -F) that are not valid in Ruby 3.x. Clear it to avoid a RuntimeError
# on startup. Explicitly force it off (rather than only ENV.delete) so that every
# subprocess we spawn below gets a clean env, regardless of what a persisted
# Windows/User/Machine environment variable re-injects into new process trees.
ENV.delete("RUBYOPT")
CLEAN_ENV = { "RUBYOPT" => nil }.freeze

# Use plain "bundle" (resolved via PATH) to avoid broken paths with spaces on Windows.
unless system(CLEAN_ENV, "bundle", "check")
  warn "Missing gems detected; running bundle install..."
  exit(1) unless system(CLEAN_ENV, "bundle", "install", "--jobs", "4", "--retry", "3")
end

# IMPORTANT: Do NOT shell out to "bundle exec cucumber" here. Spawning a brand new
# ruby.exe process for Cucumber is exactly where a stale/persisted RUBYOPT (e.g. set
# at the Windows Jenkins-service-account level) can get re-introduced into the new
# process's environment, even after we've cleared it above - causing
# "ruby.exe: invalid switch in RUBYOPT: -F (RuntimeError)" right after bundle install
# completes. Running Cucumber in-process avoids creating that extra process boundary
# entirely, so there is no new process that could ever pick up a bad RUBYOPT again.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path(File.join("..", "Gemfile"), __dir__)
require "bundler/setup"
require "cucumber/cli/main"

cucumber_args = [
  "--strict",
  "--format",
  "progress",
  "--format",
  "junit",
  "--out",
  report_dir,
  "features"
]

puts "Running cucumber (in-process) with args: #{cucumber_args.join(" ")}"
puts "JUnit reports dir: #{report_dir} (files: TEST-*.xml)"

exit_status = 0
begin
  # Cucumber::Cli::Main#execute! calls Kernel#exit internally on completion,
  # which raises SystemExit within this same process - catch it to capture
  # the real exit status instead of letting it unwind uncontrolled.
  Cucumber::Cli::Main.new(cucumber_args).execute!
rescue SystemExit => e
  exit_status = e.status
end

exit(exit_status)
