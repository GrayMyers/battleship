require "minitest/autorun"
require "minitest/pride"
require './lib/computer'
require './lib/board'
require './lib/cell'
require './lib/ship'

class ComputerTest < Minitest::Test
  def setup
    @computer = Computer.new
    @computer.create_ships
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_it_can_create_a_board
    assert_instance_of Board, @computer.board
  end

  def test_it_can_create_ships
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
    assert_equal true, coordinates.each_cons(2).all? {|pair| @computer.board.consecutive?(pair)}
  end

  def test_it_can_place_ships
    @computer.place_ships

    assert_equal 5, @computer.board.render(true).count("S")
  end

  def test_it_can_choose_a_random_coordinate_to_fire_on
  end

  def test_it_can_choose_a_valid_coordinate_to_fire_on
  end

  def test_it_does_not_duplicate_shots
  end

end
