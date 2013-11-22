require 'courgette/name_resolution'

module Courgette
  class ReferenceToDependency
    def initialize definitions
      @resolver = Courgette::NameResolution.new definitions
    end

    def transform reference
      definition = @resolver.resolve reference
      return if definition.nil?

      Dependency.new definition, reference.context.flatten
    end

    private
    attr_reader :resolver
    Dependency = Struct.new :reference, :referrer
  end
end
