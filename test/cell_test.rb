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
  end

  def test_empty
    assert_equal true, @cell.empty?

    @cell.place_ship(@ship)

    assert_equal false, @cell.empty?
  end

  def test_place_ship
    @cell.place_ship(@ship)

    assert_equal @ship, @cell.ship
  end

  def test_fire_upon
    @cell.place_ship(@ship)

    assert_equal false, @cell.fired_upon?
    assert_equal 3, @cell.ship.health

    @cell.fire_upon

    assert_equal true, @cell.fired_upon?
    assert_equal 2, @cell.ship.health
  end

  def test_render
    assert_equal ".", @cell.render

    @cell.fire_upon
    assert_equal "M", @cell.render

    cell_2 = Cell.new("A2")
    cell_2.place_ship(Ship.new("submarine", 2))
    cell_2.fire_upon

    assert_equal "H", cell_2.render
    #true case
    cell_3 = Cell.new("A3")
    cell_3.place_ship(@ship)

    assert_equal "S", cell_3.render(true)

    cell_3.fire_upon

    assert_equal "H", cell_3.render(true)

    2.times do
      cell_3.fire_upon
    end

    assert_equal "X", cell_3.render(true)
  end
end
