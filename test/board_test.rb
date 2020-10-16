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
    assert_instance_of Cell, @board.cells["D2"]
    assert_equal 16, @board.cells.size
    assert_equal true, @board.cells.key?("A1")
  end

  def test_create_empty_cells
    assert_equal ["A1", "B1", "A2", "B2"], (@board.create_empty_cells(2,2)).keys
    assert_instance_of Cell, (@board.create_empty_cells(2,2))["A1"]
  end

  def test_valid_coordinate?
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal true, @board.valid_coordinate?("D4")
    assert_equal false, @board.valid_coordinate?("A5")
    assert_equal false, @board.valid_coordinate?("Z1")
    assert_equal false, @board.valid_coordinate?("A14")
  end

  def test_check_adjacent
    assert_equal :up, @board.check_adjacent("B2","A2")
    assert_equal :down, @board.check_adjacent("B2","C2")
    assert_equal :left, @board.check_adjacent("B2","B1")
    assert_equal :right, @board.check_adjacent("B2","B3")
    assert_nil @board.check_adjacent("B2","B4")
    assert_nil @board.check_adjacent("B2","E4")
  end

  def test_valid_placement_checks_for_valid_coordinates
    assert_equal true, @board.valid_placement?(@cruiser,["A1","A2","A3"])
    assert_equal true, @board.valid_placement?(@cruiser,["A1","B1","C1"])
    assert_equal true, @board.valid_placement?(@submarine, ["C2", "D2"])
    assert_equal false, @board.valid_placement?(@cruiser,["A1","A2","Z3"])
    assert_equal false, @board.valid_placement?(@submarine, ["G8", "H8"])
  end

  def test_valid_placement_checks_ship_length
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert_equal false, @board.valid_placement?(@cruiser,["A1","A2","A3","A4"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "A2", "A3"])
  end

  def test_valid_placement_checks_coordinates_are_consecutive
    assert_equal false, @board.valid_placement?(@cruiser,["A1","D2","C3"])
    assert_equal false, @board.valid_placement?(@submarine, ["B2", "D2"])
  end

  def test_valid_placement_checks_coordinates_are_linear
    assert_equal false, @board.valid_placement?(@cruiser,["A1","A2","B2"])
  end

  def test_valid_placement_checks_for_existing_ships
    assert_equal true, @board.valid_placement?(@submarine,["A3","A4"])
    assert_equal true, @board.valid_placement?(@cruiser,["A2","B2","C2"])

    @board.place(@cruiser,["A1","A2","A3"])

    assert_equal false, @board.valid_placement?(@submarine,["A3","A4"])
    assert_equal false, @board.valid_placement?(@cruiser,["A2","B2","C2"])
  end

  def test_place
    @board.place(@cruiser,["A1","A2","A3"])
    cell1 = @board.cells["A1"]
    cell2 = @board.cells["A2"]
    cell3 = @board.cells["A3"]
    assert_equal @cruiser, cell1.ship
    assert cell1.ship == cell3.ship
    assert cell1.ship == cell2.ship
  end

  def test_render_board
    expected_empty = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
    assert_equal expected_empty, @board.render
    assert_equal expected_empty, @board.render(true)

    @board.place(@cruiser,["A1","A2","A3"])

    expected_with_ship = "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n"
    assert_equal expected_empty, @board.render
    assert_equal expected_with_ship, @board.render(true)

    @board.cells["B1"].fire_upon
    expected_empty_miss = "  1 2 3 4 \nA . . . . \nB M . . . \nC . . . . \nD . . . . \n"
    expected_with_ship_miss = "  1 2 3 4 \nA S S S . \nB M . . . \nC . . . . \nD . . . . \n"
    assert_equal expected_empty_miss, @board.render
    assert_equal expected_with_ship_miss, @board.render(true)

    @board.cells["A1"].fire_upon
    expected_empty_hit = "  1 2 3 4 \nA H . . . \nB M . . . \nC . . . . \nD . . . . \n"
    expected_with_ship_hit = "  1 2 3 4 \nA H S S . \nB M . . . \nC . . . . \nD . . . . \n"
    assert_equal expected_empty_hit, @board.render
    assert_equal expected_with_ship_hit, @board.render(true)

    @board.cells["A2"].fire_upon
    @board.cells["A3"].fire_upon
    expected_with_ship_sunk = "  1 2 3 4 \nA X X X . \nB M . . . \nC . . . . \nD . . . . \n"
    assert_equal expected_with_ship_sunk, @board.render
    assert_equal expected_with_ship_sunk, @board.render(true)
  end
end
