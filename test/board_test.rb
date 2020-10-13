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

end
