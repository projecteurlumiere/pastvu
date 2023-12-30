module Pastvu
  class BoundResponse < BasicResponse
    def clusters
      @hash ||= self.to_hash
      ClusterCollection.new @hash["result"]["clusters"]
    end

    def photos
      @hash ||= self.to_hash
      PhotoCollection.new @hash["result"]["photos"]
    end
  end
end