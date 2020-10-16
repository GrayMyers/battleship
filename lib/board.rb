require './lib/cell.rb'
require './lib/ship.rb'

class Board
  attr_reader :cells

  def initialize(width = 4,height = 4)
    @cells = create_empty_cells(width,height)
    @width = width
    @height = height
  end

  def clamp(num,min,max)
    result = [min,num,max].sort[1]
    if result != num
      puts "Warning: Number clamped to value #{result}"
    end
    result
  end

  def create_empty_cells(width,height)
    default_min = 2 #there is no reason to work with a board smaller than this
    default_y_max = 26 #to prevent invalid characters
    default_x_max = 10 #to prevent row misalignment
    width = clamp(width,default_min,default_x_max)
    width = clamp(height,default_min,default_y_max)
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

  def valid_coordinate?(coord)
    @cells.key?(coord)
  end

  def valid_placement?(ship,coords)
    coords_empty = coords.all? do |coord|
      if valid_coordinate?(coord)
        @cells[coord].empty?
      end
    end
    length_valid = (coords.count == ship.length)
    coords_consec = consecutive?(coords)
    length_valid && coords_consec && coords_empty
  end

  def consecutive?(coords)
    results = coords.each_cons(2).map do |pair|
      check_adjacent(pair[0], pair[1])
    end
    results.all? do |result|
      results.uniq.count == 1 && results.uniq != [nil]
    end
  end

  def adjacent_cells(cell)
    {
      up: (cell[0].ord - 1).chr + cell[1],
      down: (cell[0].ord + 1).chr + cell[1],
      left: cell[0] + (cell[1].to_i - 1).to_s,
      right: cell[0] + (cell[1].to_i + 1).to_s
    }
  end

  def check_adjacent(cell,cell2)
    adjacent_cells(cell).key(cell2)
  end

  def place(ship,coords)
    coords.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def render(show_ships = false)
    output_string = "  "
    @width.times do |number|
      output_string += (number + 1).to_s + " "
    end
    letters = [*"A".."Z"]
    @height.times do |y|
      output_string += "\n" + letters[y] + " "
      @width.times do |x|
        coordinate = letters[y] + (x+1).to_s
        output_string += @cells[coordinate].render(show_ships) + " "
      end
    end
    output_string + "\n"
  end
end
