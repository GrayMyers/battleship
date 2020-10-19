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
    available_cells = @user_board.cells.select {|coord, cell| !cell.fired_upon?}
    target = available_cells.keys.sample
  end

  def turn
    target = select_target
    if target != nil
      @user_board.cells[target].fire_upon
      display_shot_result(target)
    end
  end

  def display_shot_result(target)
    ship = @user_board.cells[target].ship
    if ship == nil
      puts "My shot on #{target} was a miss."
    elsif ship.sunk?
      puts "My shot on #{target} was a miss.\n I sunk your #{ship.name}!"
    else
      puts "My shot on #{target} was a hit."
    end
  end
end
