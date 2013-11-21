module Courgette
  class Graph
    attr_reader :nodes, :edges

    def initialize nodes, edges
      @nodes = nodes
      @edges = edges
    end

    def dependency_count node
      edges.select { |r| r.referrer == node }.count
    end

    def depender_count node
      edges.select { |r| r.reference == node }.count
    end

    private
  end
end
