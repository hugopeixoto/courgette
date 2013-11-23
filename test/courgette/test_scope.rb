require 'minitest_helper'
require 'courgette/scope'

class TestCourgetteScope < MiniTest::Unit::TestCase
  def setup
    @scope = Courgette::Scope.new
  end

  def test_const
    assert_equal [:Name], @scope.scope [:const, :Name]
  end

  def test_fail
    assert false
  end
end
