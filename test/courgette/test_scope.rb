require 'simplecov'
require 'minitest/autorun'
require 'courgette/scope'

class TestCourgetteScope < MiniTest::Unit::TestCase
  def setup
    @scope = Courgette::Scope.new
  end

  class ConstNode < Struct.new(:children)
    def type
      :const
    end
  end

  def test_const
    assert_equal [:Name], @scope.scope(ConstNode.new([nil, :Name]))
  end

  def test_other
    assert_equal [:potato], @scope.scope(:potato)
  end

  def test_colon2
    assert_equal [:Scoped, :Name],
      @scope.scope(ConstNode.new([ConstNode.new([nil, :Scoped]), :Name]))
  end

  def test_compose
    assert_equal [:Really, :Scoped, :Name],
      @scope.scope(
        ConstNode.new([
          ConstNode.new([
            ConstNode.new([nil, :Really]),
            :Scoped]),
          :Name]))
  end
end
