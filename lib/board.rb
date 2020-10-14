require './lib/cell.rb'

class Board
  attr_reader :cells
  def initialize(width = 4,height = 4)
    @cells = create_empty_cells(width,height)
  end

  def valid_placement?(ship,coords)
    coords.all? do |coord|
      valid_coordinate?(coord)
    end
  end

  def valid_coordinate?(cell)
    @cells.key?(cell)
  end

  def create_empty_cells(width,height)
    letters = [*"A".."Z"]
    cells = {}
    width.times do |x|
      height.times do |y|
        coordinate = letters[y] + (x+1).to_s
        cells[coordinate] = Cell.new(coordinate)
      end
    end
    cells
  end

end
