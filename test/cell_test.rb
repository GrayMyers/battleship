require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'


class CellTest < Minitest::Test

  def setup
    @cell = Cell.new("A1")
    @ship = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

  def test_attributes
    assert_equal "A1", @cell.coordinate
    assert_equal false, @cell.fired_upon?
    # assert_equal @ship, @cell.ship
  end



end
