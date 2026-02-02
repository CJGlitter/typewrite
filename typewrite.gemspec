# frozen_string_literal: true

require_relative "lib/typewrite/version"

Gem::Specification.new do |spec|
  spec.name        = "typewrite"
  spec.version     = Typewrite::VERSION
  spec.authors     = ["Cory Davis"]
  spec.email       = ["CSDavisMusic@gmail.com"]

  spec.summary     = "Typewriter effect for console output"
  spec.description = "A simple gem to add a typewriter effect to console output."
  spec.homepage    = "https://github.com/CJGlitter/typewrite"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{\A(?:test|spec|features)/})
    end
  end
  spec.require_paths = ["lib"]
end
