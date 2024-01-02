module Pastvu
  class ParamsValidator
    def self.validate(params)
      TypeCheck.validate(params) if Pastvu.config.params_type_check
      ValueCheck.validate(params) if Pastvu.config.params_value_check
    end
  end
end