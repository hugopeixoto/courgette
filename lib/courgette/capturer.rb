require 'courgette/scope'

module Courgette
  class Captured
    def initialize
      @references  = []
      @definitions = []
    end

    def add_definition definition
      @definitions << definition
    end

    def add_reference reference, context
      context = [Kernel] if context.empty?
      @references << Reference.new(reference, context)
    end

    def references
      @references.uniq! { |ref| ref.to_a }
      @references
    end

    def definitions
      @definitions.uniq! { |definition| definition.to_a }
      @definitions
    end

    private
    Reference = Struct.new :name, :context
  end

  class Capturer
    def initialize observer = nil
      @captured = observer || Captured.new
    end

    def capture sexpr
      iterate sexpr, []
    end

    def references
      @captured.references
    end

    def definitions
      @captured.definitions
    end

    private
    def add_definition definition
      @captured.add_definition definition.flatten
    end

    def add_reference context, reference
      @captured.add_reference reference, context
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
      s = scope sexpr.children[0]
      new_context = context + [s]

      add_definition new_context


      iterate_many sexpr.children[1..-1], new_context
    end

    def iterate_call sexpr, context
      iterate sexpr[1], context
      iterate_many sexpr[3..-1], context
    end

    def iterate sexpr, context
      return unless sexpr.is_a? Parser::AST::Node

      case sexpr.type
      when :const, :colon2
        add_reference context, scope(sexpr)
      when :module, :class
        iterate_definition sexpr, context
      when :casgn
        add_definition context + [sexpr.children[1]]
      else
        iterate_many sexpr.children, context
      end
    end
  end
end
