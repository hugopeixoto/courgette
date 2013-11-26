require 'simplecov'
require 'minitest/autorun'
require 'courgette/scope'

class TestCourgetteScope < MiniTest::Unit::TestCase
  def setup
    @scope = Courgette::Scope.new
  end

  def test_const
    assert_equal [:Name], @scope.scope([:const, :Name])
  end

  def test_other
    assert_equal [:potato], @scope.scope(:potato)
  end

  def test_colon2
    assert_equal [:Scoped, :Name],
      @scope.scope([:colon2, :Scoped, :Name])
  end

  def test_compose
    assert_equal [:Really, :Scoped, :Name],
      @scope.scope(
        [:colon2,
          [:colon2,
            [:const, :Really],
            [:const, :Scoped]],
          [:const, :Name]])
  end
end
