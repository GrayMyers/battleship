require './lib/ship'
require './lib/board'
require './lib/user_inferace'
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
  $computer.setup($ui.user_board, $ui.computer_board, $ui.ships)
  puts prompt_ship_placement
  determine_ship_placement
end
