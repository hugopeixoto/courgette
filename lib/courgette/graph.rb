require 'set'

module Courgette
  class Graph
    attr_reader :nodes, :edges

    def initialize nodes, edges
      @nodes = nodes
      @edges = edges

      setup_graph
    end

    def dependency_count node
      edges.select { |r| r.referrer == node }.count
    end

    def depender_count node
      edges.select { |r| r.reference == node }.count
    end

    def filter roots
      return self if roots.nil?

      visited = Set.new

      roots.each do |r|
        dfs(r, visited)
      end

      filtered_edges = edges.select { |r| visited.include? r.referrer }

      Graph.new visited.to_a, filtered_edges
    end

    attr_accessor :adjacency_list

    private
    def dfs v, visited
      return if visited.include? v

      visited << v

      adjacency_list[v].each do |w|
        dfs(w, visited) unless visited.include? w
      end
    end

    def setup_graph
      self.adjacency_list = Hash.new { |h,k| h[k] = Set.new }

      edges.each do |e|
        self.adjacency_list[e.referrer] << e.reference
      end
    end
  end
end
