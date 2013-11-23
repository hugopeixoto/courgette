require 'courgette/capturer'
require 'courgette/reference_to_dependency'
require 'courgette/file_to_sexpr'
require 'courgette/graph'

module Courgette
  class DirectoryAnalyser
    def initialize
      @capturer   = Courgette::Capturer.new
      @file2sexpr = Courgette::FileToSexpr.new
    end

    def analyse pattern
      Dir.glob(pattern) do |file|
        capturer.capture file2sexpr.convert(file)
      end
    end

    def graph
      Courgette::Graph.new definitions, dependencies
    end

    private
    attr_reader :capturer, :file2sexpr

    def definitions
      capturer.definitions
    end

    def dependencies
      r2d = Courgette::ReferenceToDependency.new definitions

      capturer.references.map do |reference|
        r2d.transform reference
      end.compact
    end
  end
end
