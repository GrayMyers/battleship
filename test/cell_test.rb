require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'

class CellTest < Minitest::Test

  def setup
    @cell = Cell.new("A1")
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

end
