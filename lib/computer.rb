require './lib/board'
require './lib/cell'
require './lib/ship'

class Computer
  attr_reader :board, :ships

  def initialize(width = 4,height = 4)
    @board = Board.new(width, height)
  end

  def create_ships(ship_types = {"Cruiser"=> 3, "Sumbarine"=> 2})
    @ships = ship_types.map do |name, length|
      Ship.new(name, length)
    end
  end
  # @ships.each do |ship|

  def generate_coordinates(length)
    coords = [@board.cells.keys.sample]
    coords << @board.adjacent_cells(coords[0]).values.find do |value|
      @board.valid_coordinate?(value)
    end
    (length-2).times do |number|
      coords = coords.sort
      dir = @board.adjacent_cells(coords[-2]).key(coords[-1])
      next_coord = @board.adjacent_cells(coords[-1])[dir]
      if @board.valid_coordinate?(next_coord)
        coords << next_coord
      elsif dir == :down
        coords << @board.adjacent_cells(coords[0])[:up]
      elsif dir == :up
        coords << @board.adjacent_cells(coords[0])[:down]
      elsif dir == :left
        coords << @board.adjacent_cells(coords[0])[:right]
      elsif dir == :right
        coords << @board.adjacent_cells(coords[0])[:left]
      end
    end
    coords = coords.sort
  end
end
