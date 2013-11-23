require 'courgette/scope'

module Courgette
  class Capturer
    def initialize
      @references  = []
      @definitions = []
    end

    def capture sexpr
      iterate sexpr, []
    end

    def references
      @references.uniq! { |reference| reference.to_a }
      @references
    end

    def definitions
      @definitions.uniq! { |definition| definition.to_a }
      @definitions
    end

    private
    Reference = Struct.new :name, :context

    def add_definition definition
      @definitions << definition.flatten
    end

    def add_reference context, reference
      @references << Reference.new(reference, context)
    end

    def scope sexpr
      Courgette::Scope.new.scope sexpr
    end

    def iterate_many sexprs, context
      sexprs.each do |sexpr|
        iterate sexpr, context
      end
    end

    def iterate_cdecl sexpr, context
      s = scope sexpr[1]
      new_context = context + [s]
      add_definition new_context

      iterate_many sexpr[2..-1], context
    end

    def iterate_definition sexpr, context
      s = scope sexpr[1]
      new_context = context + [s]
      add_definition new_context

      iterate_many sexpr[2..-1], new_context
    end

    def iterate_call sexpr, context
      iterate sexpr[1], context
      iterate_many sexpr[3..-1], context
    end


    def iterate sexpr, context
      return unless sexpr.is_a? Enumerable

      case sexpr[0]
      when :const, :colon2
        add_reference context, scope(sexpr)
      when :module, :class
        iterate_definition sexpr, context
      when :cdecl
        iterate_cdecl sexpr, context
      when :defn
        iterate_many sexpr[3..-1], context

      when :call
        iterate_call sexpr, context
      when :nil, :lit
      else
        iterate_many sexpr[1..-1], context
      end
    end
  end
end
