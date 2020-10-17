require './lib/user_interface.rb'
require './lib/board.rb'
require './lib/ship.rb'

require 'minitest/autorun'
require 'minitest/pride'

class UserInterfaceTest < Minitest::Test
  def setup
    @board = Board.new(4,4)
    @ships = [
      Ship.new("Cruiser",3),
      Ship.new("Submarine",2)
    ]
    @ui = UserInterface.new(@board,@ships)
  end

  def test_it_exists
    assert_instance_of UserInterface, @ui
  end

  def test_it_has_attributes
    assert_equal @ships, @ui.ships
    assert_equal @board, @ui.board
  end

  def test_it_prompts_play

  end
end
