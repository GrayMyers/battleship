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
    @user_ships = [Ship.new("Cruiser", 3), Ship.new("Submarine", 2)]
    @computer.setup(@user_board, @computer_board, ships)
  end

  def test_it_exists
    assert_instance_of Computer, @computer
    assert_equal [], @computer.consecutive_hits
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

  def test_turn
    assert_equal 16, @user_board.render.count(".")
    @computer.turn
    assert_equal 15, @user_board.render.count(".")
  end

  def test_select_target
    assert_instance_of String, @computer.select_target
    assert_equal true, @user_board.cells.keys.include?(@computer.select_target)
  end

  def test_random_target
    random_target = @computer.random_target
    assert_instance_of String, random_target
    assert_equal true, @user_board.cells.keys.include?(random_target)
    assert_equal false, @user_board.cells[random_target].fired_upon?
  end

  def test_predict_target
    @computer.consecutive_hits << "B2"
    @computer.consecutive_hits << "B3"
    predict_target = @computer.predict_target
    assert_instance_of String, predict_target
    assert_equal true, @user_board.cells.keys.include?(predict_target)
    assert_equal false, @user_board.cells[predict_target].fired_upon?

    @computer.consecutive_hits << "B1"

    assert_equal "B4", @computer.predict_target
  end

  def test_find_adjacent
    assert_instance_of Array, @computer.find_adjacent
  end

  def test_store_result
    @user_board.cells.values[0].place_ship(@user_ships[0])
    @user_board.cells.values[1].place_ship(@user_ships[0])
    @user_board.cells.values[2].place_ship(@user_ships[0])
    @user_board.cells.values[0].fire_upon
    @computer.store_result(@user_board.cells.values[0])

    assert_equal ["A1"], @computer.consecutive_hits

    @user_board.cells.values[1].fire_upon
    @computer.store_result(@user_board.cells.values[1])

    assert_equal ["A1","B1"], @computer.consecutive_hits

    @user_board.cells.values[2].fire_upon
    @computer.store_result(@user_board.cells.values[2])

    assert_equal [], @computer.consecutive_hits

  end
end
