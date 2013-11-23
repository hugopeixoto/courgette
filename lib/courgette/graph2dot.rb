require 'courgette/node_grouper'
require 'graph'

module Courgette
  class Graph2Dot
    def initialize &block
      @dot = digraph &block
    end

    def load graph
      calculate_distinct_namespaces graph.nodes
      set_colorscheme

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

    def set_colorscheme
      dot.colorscheme(:set2, [4, [8, @grouper.groups.count + 1].min].max)
    end

    def calculate_distinct_namespaces nodes
      @grouper = Courgette::NodeGrouper.new nodes, 8
    end

    def add_node node
      color(node) << dot.node(label(node))
    end

    def add_edge edge
      dot.edge(label(edge.referrer), label(edge.reference))
    end

    def color node
      idx = @grouper.group node

      dot.send "c#{idx}"
    end

    def label node
      node.flatten.join("::")
    end
  end
end
