require 'simplecov'
require 'minitest/autorun'
require 'courgette/reference_to_dependency'

class FakeResolver < Struct.new(:value)
  def resolve reference
    value
  end
end

class TestCourgetteReferenceToDependency < MiniTest::Unit::TestCase
  class FakeReference < Struct.new(:context)
  end

  def test_unknown_reference
    @converter = Courgette::ReferenceToDependency.new [], FakeResolver.new(nil)
    reference = FakeReference.new

    dependency = @converter.transform reference

    assert_nil dependency
  end

  def test_known_reference
    @converter = Courgette::ReferenceToDependency.new [], FakeResolver.new(42)
    reference = FakeReference.new []

    dependency = @converter.transform reference

    assert_equal 42, dependency.reference
  end

  def test_referrer
    @converter = Courgette::ReferenceToDependency.new [], FakeResolver.new(42)
    reference = FakeReference.new [[:X], [:Y]]

    dependency = @converter.transform reference

    assert_equal [:X, :Y], dependency.referrer
  end
end
