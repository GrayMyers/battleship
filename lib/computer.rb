require './lib/board'
require './lib/cell'
require './lib/ship'

class Computer
  attr_reader :board

  def initialize(width = 4,height = 4)
    @board = Board.new(width, height)
  end

end
