module Pastvu
  class Configuration
    VALID_OPTIONS = %i[
      host
      path
      user_agent
      ensure_successful_responses
      check_params_type
      check_params_value
    ]

    DEFAULT_VALUES = {
      default_host: "pastvu.com",
      default_path: "api2",
      default_user_agent: "Ruby PastVu Gem/#{VERSION}, #{RUBY_PLATFORM}, Ruby/#{RUBY_VERSION}",
      default_ensure_successful_responses: true,
      default_check_params_type: true,
      default_check_params_value: true
    }

    attr_accessor *VALID_OPTIONS

    def initialize
      reset!
    end

    def reset!
      VALID_OPTIONS.each do |option|
        self.send(option.to_s.concat("=").to_sym, DEFAULT_VALUES["default_".concat(option.to_s).to_sym])
      end
    end

    def configure
      yield self
      self
    end
  end
end