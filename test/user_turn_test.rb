require './lib/user_interface.rb'
require './lib/computer'
require './lib/board.rb'
require './lib/ship.rb'
require './lib/user_interface.rb'

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'

class UserInterfaceTest < Minitest::Test
  def setup
    @ui = UserInterface.new
    @ui.setup
    @computer = Computer.new
    @computer.setup(@ui.user_board, @ui.computer_board, @ui.computer_ships)
    @user_turn = UserTurn.new(@ui.computer_board, @ui.user_board)
  end

  def test_determine_shot
    @user_turn.stubs(:input_shot).returns("A1")
    assert_equal "A1", @user_turn.determine_shot
  end
end
