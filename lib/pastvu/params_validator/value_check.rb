require "method_source"

module Pastvu
  class ValueCheck
    VALIDATIONS = {
      distance: ->(d) { d <= 1000000 },
      geo:     [->(g) { g.size == 2 },
                ->(g) { g.all? { |coordinate| coordinate.instance_of?(Float) || coordinate.instance_of?(Integer) } }],
      geometry: ->(g) do
                  permitted_types  = %w[Polygon Multipolyigon]
                  permitted_types.any? { |t| t == g["type"] }
                end,
      limit:    ->(l) { l <= 30 },
      type:     ->(t) { [%w[photo painting].any?(t)] }
    }

    def self.validate(params)
      errors = []

      VALIDATIONS.each do |k, v|
        next if params[k].nil?
        next if v.instance_of?(Array) ? call_each(v, params[k]) : v.call(params[k])

        errors << [k, v]
      end

      if errors.empty?
        true
      else
        report_errors(errors)
      end
    end

    def self.report_errors(errors)
      report = errors.map do |error|
        error[0]
      end.join(", ")

      raise ArgumentError, "expect the following params to pass validations: #{report}"
    end

    def self.call_each(array, argument)
      array.each do |lambda|
        return false unless lambda.call(argument)
      end

      true
    end
  end
end