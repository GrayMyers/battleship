require './lib/cell.rb'

class Board
  attr_reader :cells
  def initialize(width = 4,height = 4)
    @cells = create_empty_cells(width,height)
    @width = width
    @height = height
  end

  def valid_placement?(ship,coords)
    coords_valid = coords.all? do |coord|
      valid_coordinate?(coord)
    end
    if !coords_valid
      return false
    end
    coords_empty = coords.all? do |coord|
      @cells[coord].empty?
    end

    length_valid = (coords.count == ship.length)

    coords_consec = check_consecutivity(coords)
    coords_valid &&
    length_valid &&
    coords_consec &&
    coords_empty
  end

  def place(ship,coords)
    coords.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def check_consecutivity(coords)
    index = 0
    results = []
    while index < coords.count - 1
      results << check_adjacent(coords[index],coords[index+1])
      index += 1
    end
    results.all? do |result|
      results[0] == result && result != nil
    end
  end

  def check_adjacent(cell,cell2)
    adjacent_cells = {
      up: (cell[0].ord - 1).chr + cell[1],
      down: (cell[0].ord + 1).chr + cell[1],
      left: cell[0] + (cell[1].to_i - 1).to_s,
      right: cell[0] + (cell[1].to_i + 1).to_s
    }
    adjacent_cells.key(cell2)

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

  def render(show_ships = false)
    # output_string = "  1 2 3 4 \nA "
    output_string = "  "
    @width.times do |number|
      output_string += (number + 1).to_s + " "
    end
    output_string += "\nA "
    letters = [*"A".."Z"]
    @height.times do |y|
      @width.times do |x|
        coordinate = letters[y] + (x+1).to_s
        output_string += @cells[coordinate].render(show_ships) + " "
      end
      output_string += "\n" + letters[y + 1] + " "
    end
    output_string.rstrip[0..-2]
  end
end
