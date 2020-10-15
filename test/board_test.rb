require './lib/board.rb'
require './lib/cell.rb'
require './lib/ship.rb'
require 'minitest/autorun'
require 'minitest/pride'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new(4,4)
    @cruiser = Ship.new("Cruiser",3)
    @submarine = Ship.new("Submarine",2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_attributes
    assert_instance_of Cell, @board.cells["A1"]
    assert_equal 16, @board.cells.size
  end
  def test_valid_coordinate?
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal false, @board.valid_coordinate?("Z1")
  end

  def test_that_ship_coords_are_valid
    assert_equal true, @board.valid_placement?(@cruiser,["A1","A2","A3"])
    assert_equal true, @board.valid_placement?(@cruiser,["A1","B1","C1"])

    assert_equal false, @board.valid_placement?(@cruiser,["A1","A2","Z3"])
    assert_equal false, @board.valid_placement?(@cruiser,["A1","A2","Z3"])
    assert_equal false, @board.valid_placement?(@cruiser,["A1","A2","A3","A4"])
    assert_equal false, @board.valid_placement?(@cruiser,["A1","D2","C3"])
    assert_equal false, @board.valid_placement?(@cruiser,["A1","A2","B2"])
  end

end
