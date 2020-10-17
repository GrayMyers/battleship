require './lib/ship'
require './lib/board'
require './lib/user_interface'
require './lib/computer'

$ui = UserInterface.new
$computer = Computer.new

def prompt_play
  option = $ui.determine_play
  if option == :play
    play_game
  end
end

def play_game
  $ui.setup
  $computer.setup($ui.user_board, $ui.computer_board, $ui.computer_ships)
  puts $ui.prompt_ship_placement
  $computer.place_ships
  $ui.determine_ship_placement
  until winner = $ui.winner do
    $ui.turn
    $computer.turn
  end
  puts winner
  prompt_play
end

prompt_play
