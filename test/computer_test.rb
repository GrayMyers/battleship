require "minitest/autorun"
require "minitest/pride"
require './lib/computer'
require './lib/board'
require './lib/cell'
require './lib/ship'

class ComputerTest < Minitest::Test
  def setup
    @computer = Computer.new
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_it_can_create_a_board
    assert_instance_of Board, @computer.board
  end

  def test_it_can_create_ships
    @computer.create_ships({"Cruiser"=> 3, "Sumbarine"=> 2})
    assert_instance_of Ship, @computer.ships[0]
    assert_instance_of Ship, @computer.ships[1]    
  end

  def test_it_can_generate_a_ship_placement
  end

  def test_it_can_validate_ship_placement
  end

  def test_it_can_place_ships
  end

  def test_it_can_choose_a_random_coordinate_to_fire_on
  end

  def test_it_can_choose_a_valid_coordinate_to_fire_on
  end

  def test_it_does_not_duplicate_shots
  end

end
