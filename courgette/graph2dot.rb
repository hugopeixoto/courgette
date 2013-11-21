require 'graph'

module Courgette
  class Graph2Dot
    def initialize &block
      @dot = digraph &block
    end

    def load graph
      calculate_distinct_namespaces graph.nodes

      dot.colorscheme(:set2, [4, [8, @namespaces.count + 1].min].max)

      graph.nodes.each do |node|
        add_node node
      end

      graph.edges.each do |edge|
        add_edge edge
      end
    end

    def save *args
      dot.save *args
    end

    private
    attr_reader :dot

    def calculate_distinct_namespaces nodes
      @namespaces = nodes.group_by { |n| n[0...-1][0...1] }.reject { |k,v| k.empty? || v.length < 4 }.map(&:first).uniq
    end

    def add_node node
      color(node) << dot.node(label(node))
    end

    def add_edge edge
      dot.edge(label(edge.referrer), label(edge.reference))
    end

    def color node
      idx = @namespaces.index(node[0...-1][0...1]) || -1
      idx = [2 + idx, 8].min

      dot.send "c#{idx}"
    end

    def label node
      node.flatten.join("::")
    end
  end
end
