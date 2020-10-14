require './lib/board.rb'
require './lib/cell.rb'
require 'minitest/autorun'
require 'minitest/pride'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new(4,4)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_attributes
    assert_instance_of Cell, @board.cells["A1"]
    assert_equal 16, @board.cells.size
  end
  def test_valid_coordinate?
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal false, @board.valid_coordinate?("Z1")
  end

end
