require './lib/board'
require './lib/cell'
require './lib/ship'

class Computer
  attr_reader :board, :ships, :user_board

  def setup(user_board, computer_board, ships)
    @board = computer_board
    @user_board = user_board
    @ships = ships
  end

  # def create_ships(ship_types = {"Cruiser"=> 3, "Sumbarine"=> 2})
  #   @ships = ship_types.map do |name, length|
  #     Ship.new(name, length)
  #   end
  # end

  def generate_coordinates(length)
    coords = [@board.cells.keys.sample]
    until coords.length == length
      adjacent_coords = @board.cells.keys.select do |key|
        @board.consecutive?([coords, key].flatten.sort)
      end
      coords << adjacent_coords.sample
    end
    coords.sort!
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

  def select_target
    if @int_target && !@direction
      #hit a ship last turn but doesn't know which direction it is facing

      available_hash = @int_target.adjacent_cells.select {|direction, coord| @user_board.cells[coord] && !@user_board.cells[coord].fired_upon?}
      available_cells = available_hash.values
    
    elsif @int_target
      #knows ship and direction
      if @direction == :x
        aligned = except(@int_target.adjacent_cells,[:up,:down])
      else
        aligned = except(@int_target.adjacent_cells,[:left,:right])
      end
      available_hash = aligned.select {|direction, coord| @user_board.cells[coord] && !@user_board.cells[coord].fired_upon?}
      available_cells = available_hash.values

    else
      #knows no locations of ships
      available_hash = @user_board.cells.select {|coord, cell| !cell.fired_upon?}
      available_cells = available_hash.keys
    end
    index = @direction == :x ? 0 : 1
    if available_cells.length == 0
      available_cells = @user_board.cells.select {|coord, cell| @int_target.coordinate[index] == cell.coordinate[index] && !cell.fired_upon?}.keys
    end

    available_cells.sample

  end

  def turn
    target = select_target
    cell = @user_board.cells[target]
    if target != nil
      cell.fire_upon
      if !cell.empty? #hit
        if @int_target && !@direction
          @direction = @int_target.coordinate[0] == target[0] ? :x : :y
          @int_target = cell

        elsif @direction
          @int_target = cell
        else
          @int_target = cell
        end
        if cell.ship.sunk?
          @int_target = nil
          @direction = nil
          puts "I sunk your #{cell.ship.name}!"
        end
        puts "My shot on #{target} was a hit."
      else #miss
        puts "My shot on #{target} was a miss."
      end
    end
    #output result of shot
  end

  def except(hash,keys) #I do not know why this isn't included with ruby
    keys.each do |k|
      hash.delete(k)
    end
    hash
  end
end
