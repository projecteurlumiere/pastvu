module Pastvu
  class ParamsValidator
    def self.validate(params)
      TypeCheck.validate(params) if Pastvu.config.check_params_type
      ValueCheck.validate(params) if Pastvu.config.check_params_value
    end
  end
end