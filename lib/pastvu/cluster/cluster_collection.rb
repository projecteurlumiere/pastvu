module Pastvu
  class ClusterCollection < Collection
    def initialize(attributes)
      super attributes
      @path = %w[result clusters]
      @model = Cluster
    end
  end
end