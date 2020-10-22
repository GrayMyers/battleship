require 'minitest/autorun'
require 'mocha/minitest'
require 'minitest/pride'
require './lib/board'
require './lib/cell'
require './lib/ship'
require './lib/intelligent_computer.rb'
require './lib/computer.rb'

class IntelligentComputerTest < Minitest::Test
  def setup
    @computer = Computer.new
    @user_board = Board.new
    @computer_board = Board.new
    ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
    @intelligent_computer = @computer.setup(@user_board, @computer_board, ships)
  end

  def test_it_can_choose_a_valid_coordinate_to_fire_on
    target = @intelligent_computer.select_target(@user_board)
    assert_equal String, target.class
    assert_equal true, @user_board.valid_coordinate?(target)
    assert_equal false, @user_board.cells[target].fired_upon?
  end


  def test_remove_invalid_cells_cell_helper
    @computer_board.cells["B2"].fire_upon
    expected = [
      "B2","C3","C1","D2"
    ]
    assert_equal expected, @intelligent_computer.remove_invalid_cells_string(@computer_board.cells["C2"].adjacent_cells.values).keys
  end

  def test_remove_invalid_cells_cell_helper
    @computer_board.cells["A1"].fire_upon
    @computer_board.cells["A2"].fire_upon
    @computer_board.cells["A3"].fire_upon
    @computer_board.cells["A4"].fire_upon
    expected = [
      "B1","C1","D1",
      "B2","C2","D2",
      "B3","C3","D3",
      "B4","C4","D4"
    ]
    assert_equal expected, @intelligent_computer.remove_invalid_cells_cell(@computer_board.cells).keys

  end

  
end
