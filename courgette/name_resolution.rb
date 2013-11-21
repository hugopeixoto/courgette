module Courgette
  class NameResolution
    def initialize definitions
      @definitions = definitions
    end

    def resolve reference
      definitions.find do |definition|
        match_name?(definition, reference) &&
          match_scope?(definition, reference)
      end
    end

    private
    attr_reader :definitions

    def match_name? definition, reference
      definition.last == reference.name.last
    end

    def match_scope? definition, reference
      (0..reference.context.length).any? do |level|
        reference.context[0...level].flatten + reference.name == definition
      end
    end
  end
end
