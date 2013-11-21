require 'courgette/directory_analyser'

module Courgette
  module Commands
    class Stats
      def initialize options
        @options = options
      end

      def run
        stats.each do |fanout, fanin, reference|
          print_reference fanout, fanin, reference
        end
      end

      def print_reference fo, fi, ref
        print "%8d %8d: %s\n" % [fo, fi, ref.join("::")]
      end

      private
      def glob
        @options.glob
      end

      def stats
        @stats ||= graph.nodes.map do |node|
          [
            graph.dependency_count(node),
            graph.depender_count(node),
            node
          ]
        end.sort
      end

      def graph
        @graph ||= Courgette::DirectoryAnalyser.new.tap do |da|
          da.analyse glob
        end.graph
      end
    end
  end
end
