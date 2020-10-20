require './lib/user_interface.rb'
require './lib/computer'
require './lib/board.rb'
require './lib/ship.rb'

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
    
    @ui.stubs(:get_requested_input).returns(:continue)
    assert_equal :continue, @ui.determine_play

    @ui.stubs(:get_requested_input).returns(nil)
    assert_nil @ui.determine_play
  end

  def query_custom
    skip
    @ui.stubs(:get_requested_input).returns(nil)
    assert_nil @ui.query_custom
  end

  def test_custom_board_dimensions
    skip
    @ui.stubs(:get_integer).returns(5)
    @ui.custom_board
    @ui.setup

    assert_equal 25, @ui.user_board.cells.count
  end

  def test_custom_ships
    skip
    @ui.stubs(:ships).returns([["Battleship", 5], ["Destroyer", 4]])
    @ui.setup
  require "pry"; binding.pry
    assert_equal "Battleship", @ui.user_ships[0].name


  end

  def test_it_creates_separate_objects_for_user_and_computer
    skip
    assert_instance_of Ship, @ui.user_ships[0]
    assert_instance_of Ship, @ui.computer_ships[0]
    assert_instance_of Board, @ui.user_board
    assert_instance_of Board, @ui.computer_board
    assert @ui.user_board != @ui.computer_board
    assert @ui.user_board != @computer.board
  end
end
