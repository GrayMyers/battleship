require './lib/board.rb'
require './lib/ship.rb'
require './lib/cell.rb'

class UserInterface
  attr_reader :user_board, :computer_board, :user_ships, :computer_ships

  def initialize
    @board_width = 4
    @board_height = 4
    @ships = [["Cruiser", 3], ["Sumbarine", 2]]
  end

  def setup
    board_pair = create_board
    ships_pair = create_ships
    @user_board = board_pair[0]
    @computer_board = board_pair[1]
    @user_ships = ships_pair[0]
    @computer_ships = ships_pair[1]
  end

  def create_ships
    ships = []
    @ships.sort_by! {|ship| -ship[-1]}
    2.times do
      ships << @ships.map do |ship|
        Ship.new(ship[0], ship[1])
      end
    end
    ships
  end

  def create_board
    [Board.new(@board_width,@board_height),Board.new(@board_width,@board_height)]
  end

  def determine_play
    puts "Welcome to BATTLESHIP\nEnter 'p' to play. Enter 'q' to quit."
    get_requested_input("P", "Q")
  end

  def get_requested_input(continue_key, break_key, message = "Please enter a valid option.")
    loop do
      input = gets.chomp.upcase
      if input == continue_key
        return :continue
        break
      elsif input == break_key
        return :break
        break
      else
        puts message
      end
    end
  end

  def query_custom
    puts "Enter 'd' to play with default settings,  or enter 'c' to create a custom board and ships."
    if get_requested_input("C","D") == :continue
      print "Choose board size? (y/n) "
      if get_requested_input("Y", "N") == :continue
        @default_board = false
        custom_board
      end
      print "Create custom ships? (y/n) "
      if get_requested_input("Y", "N") == :continue
        custom_ships
      end
    end
  end

  def custom_board
    print "Enter custom board width: "
    @board_width = gets.chomp.to_i
    print "Enter custom board width: "
    @board_height = gets.chomp.to_i
  end

  def custom_ships
    @ships = []
    input = ""
    until input == :continue
      print "Enter custom ship name: "
      name = gets.chomp.to_s.capitalize
      print "Enter #{name} length: "
      length = gets.chomp.to_i
      until 0 < length && length <= [@board_width, @board_height].max do
        if length < 1
          print "Length cannot be smaller than 1. Please enter another value: "
          length = gets.chomp.to_i
        elsif length > [@board_width, @board_height].max
          print "Length exceeds board size. Please enter another value: "
          length = gets.chomp.to_i
        end
      end
      if (length + @ships.sum {|ship| ship[1]}) > (@board_width * @board_height)
        puts "There is not enough space left on the board for a ship of this length. #{name} cannot be created."
      else
        @ships << [name, length]
        puts "Created custom ship #{name} with length #{length} units"
      end
      puts "Enter 'c' to create another ship, or press 'd' for done."
      input = get_requested_input("D","C")
    end
  end

  def prompt_ship_placement
    "I have laid out my ships on the grid.\n" +
    "You now need to lay out your #{@user_ships.length} ships:"
    @user_ships.map do |ship|
      "The #{ship.name} is #{ship.length} units long"
    end
  end

  def determine_ship_placement #untestable due to input required in block
    ships_index = 0
    while ships_index < (@user_ships.length)
      ship = @user_ships[ships_index]
      display_user_board
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      until determine_placement_of(ship,take_input(false)) do
        puts "Those are invalid coordinates. Please try again: "
      end
      ships_index += 1
    end
  end

  def determine_placement_of(ship,input)
    processed_input = input.gsub(",", " ").split(" ")
    if @user_board.valid_placement?(ship,processed_input)
      @user_board.place(ship,processed_input)
      true
    else
      false
    end
  end

  def prompt_shot
    "Enter the coordinate for your shot:"
  end

  def determine_shot #untestable due to input required in block
    until rtrn = input_shot(take_input(false)) do
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
      ship = cell.ship
      puts "Your shot on #{input}"+display_shot_result(!cell.empty?,ship)
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

  def display_turn_boards
    puts "=============COMPUTER BOARD============="
    display_computer_board
    puts "==============PLAYER BOARD=============="
    display_user_board
  end

  def display_user_board
    puts @user_board.render(true)
  end

  def display_computer_board(hide_ships = false)
    puts @computer_board.render(hide_ships)
  end

  def take_input(case_sensitive,show_input_symbol = true)
    if show_input_symbol
      print "> "
    end
    input = gets.chomp()
    if !case_sensitive
      input.upcase
    else
      input
    end
  end

  def turn
    display_turn_boards
    puts prompt_shot
    determine_shot
  end

  def winner
    c_ships_sunk = @computer_ships.all? do |ship|
      ship.sunk?
    end
    p_ships_sunk = @user_ships.all? do |ship|
      ship.sunk?
    end
    if c_ships_sunk
      "You won."
    elsif p_ships_sunk
      "I won."
    else
      nil
    end
  end

end
