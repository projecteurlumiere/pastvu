module Pastvu
  class ValueCheck
    VALIDATIONS = {
      distance: ->(d) { d.between?(1, 1_000_000) },
      geo:     [->(g) { g.size == 2 },
                ->(g) { g.all? { |coordinate| coordinate.instance_of?(Float) || coordinate.instance_of?(Integer) } }],
      geometry: ->(g) do
                  begin
                    permitted_types  = %w[Polygon Multipolyigon]
                    permitted_types.any? { |t| t == g["type"] }
                  rescue TypeError
                    false
                  end
                end,
      limit:    ->(l) { l.between?(1, 30) },
      type:     ->(t) { %w[photo painting].any?(t.downcase) }
    }

    def self.validate(params)
      errors = {}

      VALIDATIONS.each do |k, v|
        next if params[k].nil?

        next if v.instance_of?(Array) ? call_each(v, params[k]) : v.call(params[k])

        errors.merge!({ k.to_sym => [params[k], v] })
      end

      if errors.empty?
        true
      else
        report_errors(errors)
      end
    end

    def self.report_errors(errors)
      report = errors.map do |k, v|
        "\n#{k}: #{v[0]}"
      end.join(", ")

      raise ArgumentError, "expect params to pass validations\n #{report}"
    end

    def self.call_each(array, argument)
      array.each do |lambda|
        return false unless lambda.call(argument)
      end

      true
    end
  end
end