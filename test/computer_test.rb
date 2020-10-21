require "minitest/autorun"
require "minitest/pride"
require './lib/computer'
require './lib/board'
require './lib/cell'
require './lib/ship'

class ComputerTest < Minitest::Test
  def setup
    @computer = Computer.new
    @user_board = Board.new
    @computer_board = Board.new
    ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
    @computer.setup(@user_board, @computer_board, ships)
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_it_has_a_board
    assert_instance_of Board, @computer.board
    assert_equal true, @computer.board != @user_board
  end

  def test_it_has_ships
    assert_instance_of Ship, @computer.ships[0]
    assert_instance_of Ship, @computer.ships[1]
  end

  def test_it_can_generate_coordinates
    coordinates = @computer.generate_coordinates(3)
    assert_equal 3, coordinates.count

    coordinates = @computer.generate_coordinates(4)
    assert_equal 4, coordinates.count

    assert_equal true, coordinates.all? {|coord| @computer.board.valid_coordinate?(coord)}
    assert_equal true, @computer.board.consecutive?(coordinates)
  end

  def test_it_can_place_ships
    @computer.place_ships
    assert_equal 5, @computer.board.render(true).count("S")
  end

  def test_it_can_choose_a_valid_coordinate_to_fire_on
    target = @computer.select_target
    assert_equal String, target.class
    assert_equal true, @user_board.valid_coordinate?(target)
    assert_equal false, @user_board.cells[target].fired_upon?
  end

  def test_turn
    assert_equal 0, @user_board.render.count("M")

    @computer.turn
    assert_equal 1, @user_board.render.count("M")

    @computer.turn
    assert_equal 2, @user_board.render.count("M")
  end



  def test_except_helper_method
    input_hash = {
      a: 1,
      b: 2,
      c: 3,
      d: 4
    }
    expected_output = {
      a: 1,
      d: 4
    }
    assert_equal expected_output, @computer.except(input_hash,[:b,:c])
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
    assert_equal expected, @computer.remove_invalid_cells_cell(@computer_board.cells).keys
  end
end
