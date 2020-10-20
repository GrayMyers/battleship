require './lib/user_interface.rb'
require './lib/computer'
require './lib/board.rb'
require './lib/ship.rb'

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'

class CustomOptionsTest < Minitest::Test
  def setup
    @ui = UserInterface.new
    @ui.setup
    @custom = CustomOptions.new
    @computer = Computer.new
    @computer.setup(@ui.user_board, @ui.computer_board, @ui.computer_ships)
  end

  def test_it_exists
    assert_instance_of CustomOptions, @custom
  end

  def query_custom
    @ui.stubs(:get_requested_input).returns(nil)
    assert_nil @ui.query_custom
  end

  def test_custom_board_dimensions
    @ui.stubs(:get_integer).returns(5)
    @ui.custom_board
    @ui.setup

    assert_equal 25, @ui.user_board.cells.count
  end

  def test_custom_ships
    @ui.stubs(:ships).returns([["Battleship", 5], ["Destroyer", 4]])
    @ui.setup
  require "pry"; binding.pry
    assert_equal "Battleship", @ui.user_ships[0].name
  end

end
