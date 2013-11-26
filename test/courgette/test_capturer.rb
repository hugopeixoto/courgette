require 'simplecov'
require 'minitest/autorun'
require 'courgette/capturer'
require 'mocha/setup'

class TestCourgetteCaptured < MiniTest::Unit::TestCase
  def setup
    @object = Courgette::Captured.new
  end

  def test_definition
    @object.add_definition [:A]

    assert_equal [:A], @object.definitions.first
  end

  def test_reference
    @object.add_reference "name", "context"

    assert_equal "name", @object.references.first.name
    assert_equal "context", @object.references.first.context
  end

  def test_duplicate_definitions
    @object.add_definition [:A]
    @object.add_definition [:A]

    assert_equal 1, @object.definitions.count
  end

  def test_duplicate_references
    @object.add_reference "name", "context"
    @object.add_reference "name", "context"

    assert_equal 1, @object.references.count
  end
end

class TestCourgetteCapturer < MiniTest::Unit::TestCase
  def setup
    @observer = mock()
    @object = Courgette::Capturer.new @observer
  end

  def test_references_delegation
    @observer.expects(:references).once

    @object.references
  end

  def test_definitions_delegation
    @observer.expects(:definitions).once

    @object.definitions
  end

  def test_class_definition
    @observer.expects(:add_definition).with([:X]).once

    @object.capture [:class, :X]
  end

  def test_module_definition
    @observer.expects(:add_definition).with([:M]).once

    @object.capture [:module, :M]
  end

  def test_class_inside_module
    @observer.expects(:add_definition).with([:M]).once
    @observer.expects(:add_definition).with([:M, :C]).once

    @object.capture [:module, :M, [:class, :C]]
  end

  def test_constant_declaration
    @observer.expects(:add_definition).with([:C]).once

    @object.capture [:cdecl, :C, [:lit, 1]]
  end

  def test_scoped_definition
    @observer.expects(:add_definition).with([:M, :C]).once

    @object.capture [:module, [:colon2, [:const, :M], :C]]
  end

  def test_reference
    @observer.expects(:add_reference).with([:C], []).once

    @object.capture [:const, :C]
  end

  def test_class_call
    @observer.expects(:add_reference).with([:C], []).once

    @object.capture [:call, [:const, :C], :new]
  end

  def test_reference_in_method
    @observer.expects(:add_reference).with([:C], []).once

    @object.capture [:defn, :bananas, [], [:const, :C]]
  end

  def test_others
    @object.capture [:if, [:lit, 42]]
  end
end
