

class Computer
  attr_reader :board, :ships, :user_board, :consecutive_hits

  def setup(user_board, computer_board, ships)
    @board = computer_board
    @user_board = user_board
    @ships = ships
    @consecutive_hits = []
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
    target = select_target
    cell = @user_board.cells[target]
    cell.fire_upon
    display_result(target)
    store_result(cell)
  end

  def select_target
    if @consecutive_hits == []
      random_target
    else
      predict_target
    end
  end

  def random_target
    avail_targets = @user_board.cells.select do |coordinate, cell|
      !cell.fired_upon?
    end
    avail_targets.keys.sample
  end

  def predict_target
    avail_targets = find_adjacent.flatten
    avail_targets.find do |coordinate|
      not_fired_upon = !@user_board.cells[coordinate].fired_upon?
      consecutive_to_hit = @user_board.consecutive?([@consecutive_hits, coordinate].flatten.sort)
      not_fired_upon && consecutive_to_hit
    end
  end

  def find_adjacent
    @consecutive_hits.map do |coord|
      @user_board.cells[coord].adjacent_cells.values.select do |value|
        @user_board.valid_coordinate?(value)
      end
    end
  end

  def store_result(cell)
    if !cell.empty? && cell.ship.sunk?
      @consecutive_hits = []
    elsif !cell.empty?
      @consecutive_hits << cell.coordinate
    end
  end

  def display_result(target)
    ship = @user_board.cells[target].ship
    if ship == nil
      puts "My shot on #{target} was a miss."
    elsif ship.sunk?
      puts "My shot on #{target} was a hit.\nI sunk your #{ship.name}!"
    else
      puts "My shot on #{target} was a hit."
    end
  end
end
