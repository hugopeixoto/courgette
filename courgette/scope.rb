module Courgette
  class Scope
    def scope sexpr
      case sexpr[0]
      when :colon2
        scope(sexpr[1]) + scope(sexpr[2])
      when :const
        scope sexpr[1]
      else
        [sexpr]
      end
    end
  end
end
