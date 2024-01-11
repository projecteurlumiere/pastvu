module Pastvu
  class TypeCheck
    ALLOWED_TYPES = {
      cid:        Integer,
      distance:   Integer, # <= 1000000 (meters)
      except:     Integer,
      geo:        Array, # [lat and lon]
      geometry:   Hash, # [geoJSON]
      isPainting: [TrueClass, FalseClass],
      limit:      Integer, # <= 30
      localWork:  [TrueClass, FalseClass],
      skip:       Integer,
      type:       String, # "photo" or "painting"
      year:       Integer,
      year2:      Integer,
      z:          Integer
    }

    def self.validate(params)
      errors = {}
      ALLOWED_TYPES.each do |k, type|
        param = params[k]
        next if param.nil?
        next if self.correct_type? param, type

        errors.merge!({ k.to_sym => [param, type] })
      end

      errors.empty? ? true : report_errors(errors)
    end

    def self.report_errors(errors)
      report = errors.map do |k, v|
        "\n#{k}: #{v[0]} must be #{v[1]}"
      end.join(", ")

      raise ArgumentError, "expect correct params type\n #{report}"
    end

    def self.correct_type?(param, type)
      if type.instance_of?(Array)
        type.any? { |type| param.instance_of?(type) }
      else
        param.instance_of?(type)
      end
    end
  end
end