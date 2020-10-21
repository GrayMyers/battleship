require './lib/user_interface.rb'
require './lib/computer'
require './lib/board.rb'
require './lib/ship.rb'
require './lib/custom_options'

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'

class CustomOptionsTest < Minitest::Test
  def setup
    @custom = CustomOptions.new
    @ui = UserInterface.new
  end

  def test_it_exists
    assert_instance_of CustomOptions, @custom
    assert_equal 4, @custom.board_width
    assert_equal 4, @custom.board_height
    assert_equal [], @custom.ships
  end

  def test_query_board
    @custom.stubs(:get_requested_input).returns(nil)
    assert_equal 4, @custom.board_width
    assert_equal 4, @custom.board_height
  end

  def test_custom_board
    @custom.stubs(:get_integer).returns(5)
    @custom.choose_custom_board

    assert_equal 5, @custom.board_width
    assert_equal 5, @custom.board_height
  end

  def test_query_ships
    @custom.stubs(:get_requested_input).returns(nil)
    assert_nil @custom_ships

    @custom.stubs(:get_requested_input).returns(:continue)
    @custom.expects(:custom_ships).at_least_once
    @custom.query_ships
  end

  def test_custom_ships
    @ui.stubs(:ships).returns([["Battleship", 5], ["Destroyer", 4]])
    @ui.setup
    assert_equal "Battleship", @ui.user_ships[0].name
  end

end
