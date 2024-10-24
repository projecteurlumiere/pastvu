# frozen_string_literal: true

require_relative "lib/pastvu/version"

Gem::Specification.new do |spec|
  spec.name = "pastvu"
  spec.version = Pastvu::VERSION
  spec.authors = ["projecteurlumiere"]
  spec.email = ["129510705+projecteurlumiere@users.noreply.github.com"]
  spec.homepage = "https://github.com/projecteurlumiere/pastvu"
  spec.summary = "A Ruby wrapper for PastVu API"

  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .rspec .circleci appveyor Gemfile])
    end
  end

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.19"
end
