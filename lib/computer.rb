require './lib/board'
require './lib/cell'
require './lib/ship'

class Computer
  attr_reader :board, :ships

  def initialize(width = 8,height = 8)
    @board = Board.new(width, height)
  end

  def create_ships(ship_types = {"Cruiser"=> 3, "Sumbarine"=> 2})
    @ships = ship_types.map do |name, length|
      Ship.new(name, length)
    end
  end

  def generate_coordinates(length)
    coords = [@board.cells.keys.sample]
    coords << @board.adjacent_cells(coords[0]).values.shuffle.find do |value|
      @board.valid_coordinate?(value)
    end
    (length-2).times do |number|
      coords = coords.sort
      dir = @board.adjacent_cells(coords[-2]).key(coords[-1])
      next_coord = @board.adjacent_cells(coords[-1])[dir]
      if @board.valid_coordinate?(next_coord)
        coords << next_coord
      else
        directions = {:down=>:up, :up=>:down, :left=>:right, :right=>:left}
        opposite = directions[dir]
        coords << @board.adjacent_cells(coords[0])[opposite]
      end
    end
    coords = coords.sort
  end

  def place_ships
    @ships.each do |ship|
      coords = generate_coordinates(ship.length)
      until @board.valid_placement?(ship,coords)
        coords = generate_coordinates(ship.length)
      end
      @board.place(ship,coords)
    end
  end
end
