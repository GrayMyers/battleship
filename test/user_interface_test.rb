require './lib/user_interface.rb'
require './lib/board.rb'
require './lib/ship.rb'

require 'minitest/autorun'
require 'minitest/pride'

class UserInterfaceTest < Minitest::Test
  def setup
    @player_board = Board.new(4,4)
    @computer_board = Board.new(4,4)
    @player_ships = [
      Ship.new("Cruiser",3),
      Ship.new("Submarine",2)
    ]
    @computer_ships = [
      Ship.new("Cruiser",3),
      Ship.new("Submarine",2)
    ]
    @ui = UserInterface.new(@player_board,@computer_board,@player_ships,@computer_ships)
  end

  def test_it_exists
    require "pry";binding.pry
    assert_instance_of UserInterface, @ui
  end

  def test_it_has_attributes
    assert_equal @player_ships, @ui.player_ships
    assert_equal @computer_ships, @ui.computer_ships
    assert_equal @player_board, @ui.player_board
    assert_equal @computer_board, @ui.computer_board
  end

  def test_it_prompts_play
    assert_equal "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit.",@ui.prompt_play
  end


end
