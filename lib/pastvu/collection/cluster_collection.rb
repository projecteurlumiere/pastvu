module Pastvu
  class ClusterCollection < BasicResponse
    def each
      @hash ||= self.to_hash
      @hash["result"]["clusters"].each do |cluster_hash|
        yield Cluster.new cluster_hash
      end
    end
  end
end