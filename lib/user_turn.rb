class UserTurn

  def initialize(computer_board, user_board)
    @computer_board = computer_board
    @user_board = user_board
    turn
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
      "miss."
    elsif cell.ship.sunk?
      "hit.\nYou sunk my #{cell.ship.name}!"
    else
      "hit."
    end
  end
end
