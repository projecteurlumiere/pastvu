require "json"

module Pastvu
  class Parser
    def self.to_json(hash)
      JSON.dump(hash)
    end

    def self.to_hash(json)
      hash = JSON.parse(json)
      # symbolize_keys hash
    end

    # def self.symbolize_keys(hash)
    #   hash.transform_keys do |k|
    #     k.to_sym
    #     symbolize_keys(hash[k]) if hash[k].instance_of?(Hash)
    #   end
    # end
  end
end