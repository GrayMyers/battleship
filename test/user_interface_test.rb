require './lib/user_interface.rb'
require './lib/computer'
require './lib/board.rb'
require './lib/ship.rb'
require './lib/custom_options'

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'

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

  def test_determine_play
    @ui.stubs(:get_requested_input).returns(nil)
    assert_nil @ui.determine_play
  end

  def query_custom
    @ui.stubs(:get_requested_input).returns(nil)

    assert_nil @ui.query_custom
    assert_nil @ui.custom
  end

  def test_it_creates_separate_objects_for_user_and_computer
    @ui.setup

    assert_instance_of Ship, @ui.user_ships[0]
    assert_instance_of Ship, @ui.computer_ships[0]
    assert_instance_of Board, @ui.user_board
    assert_instance_of Board, @ui.computer_board
    assert @ui.user_board != @ui.computer_board
    assert @ui.user_board != @computer.board
  end

  def test_prompt_ship_placement
   expected = ["The Cruiser is 3 units long", "The Sumbarine is 2 units long"]
   assert_equal expected, @ui.prompt_ship_placement
  end

  def test_place_ship
    assert_equal true, @ui.place_ship(@user_ships[0], ["A1", "A2", "A3"])
    assert_equal false, @ui.place_ship(@user_ships[0], ["A1", "A2", "A5"])
  end
  
end
