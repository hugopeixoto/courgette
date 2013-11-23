module Courgette
  class NodeGrouper
    def initialize nodes, max_groups
      @nodes = nodes
      @max_groups = max_groups

      calculate
    end

    def group node
      idx   = namespaces.index node[0...-1][0...1]
      idx ||= -1
      idx   = [2 + idx, @max_groups].min
    end

    def groups
      @namespaces
    end

    private
    attr_reader :nodes, :namespaces

    def calculate
      @namespaces = nodes.
        group_by { |n| n[0...-1][0...1] }.
        reject { |k, v| k.empty? || v.length < 4 }.
        map(&:first).
        uniq
    end
  end
end
