require 'courgette/directory_analyser'
require 'courgette/graph2dot'

module Courgette
  module Commands
    class Graph
      def initialize options
        @options = options
      end

      def run
        factory.load filtered_graph

        formats.each do |fmt|
          factory.save name, fmt
        end
      end

      private
      def glob
        @options.glob
      end

      def formats
        Array(@options.format)
      end

      def name
        @options.name
      end

      def factory
        @factory ||= Courgette::Graph2Dot.new do
          boxes
          node_attribs << filled
        end
      end

      def filtered_graph
        @filtered_graph ||= graph.filter filter_nodes
      end

      def filter_nodes
        return nil if @options.filter.nil?

        @options.filter.split(',').map do |root|
          root.split("::").map(&:to_sym)
        end
      end

      def graph
        @graph ||= Courgette::DirectoryAnalyser.new.tap do |da|
          da.analyse glob
        end.graph
      end
    end
  end
end
