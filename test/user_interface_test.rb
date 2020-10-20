require './lib/user_interface.rb'
require './lib/computer'
require './lib/board.rb'
require './lib/ship.rb'

require 'minitest/autorun'
require 'minitest/pride'

class UserInterfaceTest < Minitest::Test
  def setup
    @ui = UserInterface.new
    @ui.setup
    @computer = Computer.new
    @computer.setup(@ui.user_board, @ui.computer_board, @ui.computer_ships)
  end

  def test_it_exists
    assert_instance_of UserInterface, @ui
  end

  def test_it_creates_separate_objects_for_user_and_computer
    assert_instance_of Ship, @ui.user_ships[0]
    assert_instance_of Ship, @ui.computer_ships[0]
    assert_instance_of Board, @ui.user_board
    assert_instance_of Board, @ui.computer_board
    assert @ui.user_board != @ui.computer_board
    assert @ui.user_board != @computer.board
  end

end
