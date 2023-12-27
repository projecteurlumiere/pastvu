module Pastvu
  class Configuration
    VALID_OPTIONS = %i[
      host
      path
      output_format
    ]

    DEFAULT_VALUES = {
      default_host: "pastvu.com",
      default_path: "/api2",
      default_output_format: :json
      # available formats: :json, :hash
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