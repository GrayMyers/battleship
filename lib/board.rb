require './lib/cell.rb'

class Board
  attr_reader :cells
  def initialize(width = 4,height = 4)
    @cells = create_empty_cells(width,height)
  end

  private

  def create_empty_cells(width,height)
    letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    cells = {}
    width.times do |x|
      height.times do |y|
        coordinate = letters[y] + x.to_s
        cells[coordinate] = Cell.new(coordinate)
      end
    end
    cells
  end

end
