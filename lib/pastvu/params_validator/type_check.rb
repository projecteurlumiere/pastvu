module Pastvu
  class TypeCheck
    ALLOWED_TYPES = {
      cid:       Integer,
      distance:  Integer, # <= 1000000 (meters)
      except:    Integer,
      geo:       Array, # [lat and lon]
      geometry:  Hash, # [geoJSON]
      isPaiting: TrueClass || FalseClass,
      limit:     Integer, # <= 30
      localWork: TrueClass || FalseClass,
      skip:      Integer,
      type:      String, # "photo" or "painting"
      year:      Integer,
      year2:     Integer,
      z:         Integer
    }

    def self.validate(params)
      errors = []
      ALLOWED_TYPES.each do |k, v|
        next if params[k].nil?
        next if params[k].instance_of?(v)

        errors << [k, v]
      end

      errors.empty? ? true : report_errors(errors)
    end

    def self.report_errors(errors)
      report = errors.map do |e|
        "#{e[0]} must be #{e[1]}"
      end.join(", ")

      raise ArgumentError, "expect correct params type: #{report}"
    end
  end
end