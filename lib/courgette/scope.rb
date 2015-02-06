module Courgette
  class Scope
    def scope sexpr
      if sexpr.respond_to? :type
        sexpr.children.flat_map { |c| scope c }
      else
        [sexpr].compact
      end
    end
  end
end
