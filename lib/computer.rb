require './lib/board'
require './lib/cell'
require './lib/ship'

class Computer
  attr_reader :board, :ships

  ship_types = {"Cruiser"=> 3, "Sumbarine"=> 2}
  #we could also pass these values from the runner file

  def initialize(width = 4,height = 4)
    @board = Board.new(width, height)
  end

  def create_ships(ship_types)
    @ships = ship_types.map do |name, length|
      Ship.new(name, length)
    end
  end

end
