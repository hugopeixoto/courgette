require 'simplecov'
require 'minitest/autorun'
require 'courgette/name_resolution'

FakeReference = Struct.new :name, :context

class TestCourgetteNameResolution < MiniTest::Unit::TestCase
  def create definitions
    @resolver = Courgette::NameResolution.new definitions
  end

  def test_root_level
    create [[:RootA], [:RootB]]

    ref = FakeReference.new [:RootA], []

    assert_equal [:RootA], @resolver.resolve(ref)
  end

  def test_root_unknown
    create [[:Root]]

    ref = FakeReference.new [:Unknown], []

    assert_equal nil, @resolver.resolve(ref)
  end

  def test_top_definition_referenced_from_nested
    create [[:Root]]

    ref = FakeReference.new [:Root], [[:A, :B]]
    assert_equal [:Root], @resolver.resolve(ref)
  end

  def test_nested_definition_referenced_from_nested
    create [[:Scoped, :Name]]

    ref = FakeReference.new [:Name], [[:Scoped]]
    assert_equal [:Scoped, :Name], @resolver.resolve(ref)
  end

  def test_double_scope
    definition = [:Potato, :Scoped, :Name]
    create [definition]

    ref = FakeReference.new [:Name], [[:Potato], [:Scoped]]
    assert_equal definition, @resolver.resolve(ref)
  end

  def test_grouped_double_scope
    definition = [:Potato, :Scoped, :Name]
    create [definition]

    ref = FakeReference.new [:Name], [[:Potato, :Scoped]]
    assert_equal definition, @resolver.resolve(ref)
  end

  def test_scoped_definition_referenced_double
    definition = [:Potato, :Name]
    create [definition]

    ref = FakeReference.new [:Name], [[:Potato], [:Scoped]]
    assert_equal definition, @resolver.resolve(ref)
  end

  def test_scoped_definition_referenced_grouped
    definition = [:Potato, :Name]
    create [definition]

    ref = FakeReference.new [:Name], [[:Potato, :Scoped]]
    assert_equal nil, @resolver.resolve(ref)
  end

  def test_ambiguous_reference_from_specific_context
    definitions = [[:Potato, :Name], [:Name]]
    create definitions

    ref = FakeReference.new [:Name], [[:Potato]]

    assert_equal [:Potato, :Name], @resolver.resolve(ref)
  end

  def test_ambiguous_reference_from_specific_context_different_creation_order
    definitions = [[:Name], [:Potato, :Name]]
    create definitions

    ref = FakeReference.new [:Name], [[:Potato]]

    assert_equal [:Potato, :Name], @resolver.resolve(ref)
  end

  def test_ambiguous_reference_from_global_context
    definitions = [[:Potato, :Name], [:Name]]
    create definitions

    ref = FakeReference.new [:Name], []

    assert_equal [:Name], @resolver.resolve(ref)
  end

  def test_ambiguous_reference_from_global_context_different_creation_order
    definitions = [[:Name], [:Potato, :Name]]
    create definitions

    ref = FakeReference.new [:Name], []

    assert_equal [:Name], @resolver.resolve(ref)
  end
end
