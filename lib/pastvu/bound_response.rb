module Pastvu
  class BoundResponse < BasicResponse
    def clusters
      @hash ||= self.to_hash
      ClusterCollection.new @hash
    end

    def photos
      @hash ||= self.to_hash
      hash = @hash.clone
      hash["result"]["clusters"] = []
      PhotoCollection.new @hash
    end
  end
end