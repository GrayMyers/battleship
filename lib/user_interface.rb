require './lib/board.rb'
require './lib/ship.rb'
require './lib/cell.rb'

class UserInterface
  attr_reader :player_board, :computer_board, :ships
  def initialize(player_board,computer_board,player_ships,computer_ships)
    @player_board = player_board
    @computer_board = computer_board
    @player_ships = player_ships
    @computer_ships = computer_ships
  end

  def prompt_play
    "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit."
  end

  def determine_play
    puts prompt_play
    until input = process_play(take_input(false)) do
      puts "Please enter a valid option."
    end
    input
  end

  def process_play(input)
    if input == "P"
      :play
    elsif input == "Q"
      :quit
    else
      nil
    end
  end


  def prompt_ship_placement
    output_str = "I have laid out my ships on the grid.\n"
    output_str += "You now need to lay out your two ships\n" #CHANGE LATER
    ship_info_str = ""
    ships.each do |ship|
      ship_info_str += "the #{ship.name} is #{ship.length} units long and "
    end
    output_str + ship_info_str[0..-6].capitalize + "."
  end

  def determine_ship_placement #untestable due to input required in block
    ships_to_place = @player_ships
    while ships_to_place.length > 0
      ship = ships_to_place[0]
      display_player_board
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      until determine_placement_of(ship,take_input(false)) do
        puts "Those are invalid coordinates. Please try again: "
      end
      ships_to_place.shift

    end
  end

  def determine_placement_of(ship,input)
    processed_input = input.gsub(",", " ").split(" ")
    if @player_board.valid_placement?(ship,processed_input)
      @player_board.place(ship,processed_input)
      true
    else
      false
    end
  end


  def prompt_shot
    puts "Enter the coordinate for your shot:"
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
    display_player_board
  end

  def display_player_board
    puts @player_board.render(true)
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
    prompt_shot
    determine_shot
  end

  def winner
    c_ships_sunk = @computer_ships.all? do |ship|
      ship.sunk?
    end
    p_ships_sunk = @player_ships.all? do |ship|
      ship.sunk?
    end
    if c_ships_sunk
      :player
    elsif p_ships_sunk
      :computer
    else
      nil
    end
  end

end
