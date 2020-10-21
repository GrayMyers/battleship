require './lib/board'
require './lib/cell'
require './lib/ship'
require './lib/intelligent_computer.rb'

class Computer
  attr_reader :board, :ships, :user_board, :intelligent_computer
  attr_accessor :last_hit
  def setup(user_board, computer_board, ships)
    @board = computer_board
    @user_board = user_board
    @ships = ships
    @intelligent_computer = IntelligentComputer.new(user_board,computer_board)
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


  def turn
    target = @intelligent_computer.select_target()
    cell = @user_board.cells[target]
    if target != nil
      cell.fire_upon
      if !cell.empty? #hit
        @intelligent_computer.analyze_hit(target)
        if cell.ship.sunk?
          @intelligent_computer.analyze_sunk
          puts "I sunk your #{cell.ship.name}!"
        end
        puts "My shot on #{target} was a hit."
      else #miss
        puts "My shot on #{target} was a miss."
      end
    end
    #output result of shot
  end
end
