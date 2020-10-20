require './lib/board.rb'
require './lib/ship.rb'
require './lib/cell.rb'

class UserInterface
  attr_reader :user_board, :computer_board, :user_ships, :computer_ships

  def determine_play
    puts "Welcome to BATTLESHIP\nEnter 'p' to play. Enter 'q' to quit."
    get_requested_input("P", "Q")
  end

  def setup
    @user_board = create_board
    @computer_board = create_board
    @user_ships = create_ships
    @computer_ships = create_ships
  end

  def create_ships
    if @ships == nil
      [Ship.new("Cruiser", 3), Ship.new("Sumbarine", 2)]
    else
      @ships.map do |ship|
        Ship.new(ship[0], ship[1])
      end
    end
  end

  def create_board
    if @board_width = nil
      Board.new
    else
      Board.new(@board_width, @board_height)
    end
  end

  def prompt_ship_placement
    "I have laid out my ships on the grid.\n" +
    "You now need to lay out your #{@user_ships.length} ships:"
    @user_ships.map do |ship|
      "The #{ship.name} is #{ship.length} units long"
    end
  end

  def determine_ship_placement
    ships_index = 0
    while ships_index < (@user_ships.length)
      ship = @user_ships[ships_index]
      display_user_board
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      until place_ship(ship, input = gets.chomp.upcase) do
        puts "Those are invalid coordinates. Please try again: "
      end
      ships_index += 1
    end
  end

  def place_ship(ship,input)
    processed_input = input.gsub(",", " ").split(" ")
    if @user_board.valid_placement?(ship,processed_input)
      @user_board.place(ship,processed_input)
      true
    end
  end

  def turn
    display_turn_boards
    puts "Enter the coordinate for your shot:"
    determine_shot
  end

  def display_turn_boards
    puts "\n=============COMPUTER BOARD============="
    display_computer_board
    puts "==============PLAYER BOARD=============="
    display_user_board
  end

  def display_user_board
    puts @user_board.render(true)
  end

  def display_computer_board
    puts @computer_board.render
  end

  def determine_shot
    until rtrn = input_shot(gets.chomp.upcase) do
      if rtrn == false
        puts "You already shot there.  Please pick a new coordinate:"
      else
        puts "Please enter a valid coordinate:"
      end
    end
  end

  def input_shot(input)
    cell = @computer_board.cells[input]
    if !cell
      nil
    elsif cell.fired_upon?
      false
    else
      cell.fire_upon
      puts "Your shot on #{input}"+display_shot_result(!cell.empty?,cell.ship)
      true
    end
  end

  def display_shot_result(hit,ship)
    if hit && ship.sunk?
      " was a hit.\nYou sunk my #{ship.name}!"
    elsif hit
      " was a hit."
    else
      " was a miss."
    end
  end

  def winner
    if @computer_ships.all? {|ship| ship.sunk?}
      "You won."
    elsif @user_ships.all? {|ship| ship.sunk?}
      "I won."
    else
      nil
    end
  end
end
