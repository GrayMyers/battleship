require './lib/board.rb'
require './lib/ship.rb'
require './lib/cell.rb'
require './lib/custom_options'

class UserInterface
  attr_reader :user_board, :computer_board, :user_ships, :computer_ships

  def get_requested_input(continue_key, break_key)
    until (input = gets.chomp.to_s.upcase) == break_key
      if input == continue_key
        return :continue
        break
      else
        puts "Please enter a valid option."
      end
    end
  end

  def determine_play
    puts "Welcome to BATTLESHIP\nEnter 'p' to play. Enter 'q' to quit."
    if (response = get_requested_input("P", "Q")) == :continue
      query_custom
    end
    response
  end

  def query_custom
    puts "Enter 'd' to play with default settings,  or enter 'c' to create a custom board and ships."
    if get_requested_input("C","D") == :continue
      @custom = CustomOptions.new
    else
      @custom = nil
    end
  end

  def setup
    @user_board = create_board
    @computer_board = create_board
    @user_ships = create_ships
    @computer_ships = create_ships
  end

  def create_board
    if @custom
      Board.new(@custom.board_width, @custom.board_height)
    else
      Board.new
    end
  end

  def create_ships
    if @custom && @custom.ships != []
      @custom.ships.map do |ship|
        Ship.new(ship[0], ship[1])
      end
    else
      [Ship.new("Cruiser", 3), Ship.new("Sumbarine", 2)]
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
    target = determine_shot
    display_shot_result(target)
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

  def input_shot
    until @computer_board.cells.key?(input = gets.chomp.to_s.upcase) do
      puts "Please enter a valid coordinate:"
    end
    input
  end

  def determine_shot
    until !@computer_board.cells[input = input_shot].fired_upon? do
      puts "You already shot there. Please pick a new coordinate:"
    end
    @computer_board.cells[input].fire_upon
    input
  end

  def display_shot_result(target)
    cell = @computer_board.cells[target]
    puts "Your shot on #{target} was a #{result(cell)}"
  end

  def result(cell)
    if cell.empty?
      print "miss."
    elsif cell.ship.sunk?
      print "hit.\nYou sunk my #{cell.ship.name}!"
    else
      print "hit."
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
