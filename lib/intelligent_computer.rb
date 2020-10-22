class IntelligentComputer
  attr_accessor :last_hit
  def initialize
    @ship_info = Hash.new{|hash,key| hash[key] = []}
  end

  def select_target(board)
    intended_target = remove_invalid_cells_cell(board.cells).keys.sample
    if @ship_info.length > 0
      @targetted_ship = @ship_info.to_a[0][0] if !@targetted_ship
      intelligent_target = find_consective(board,@targetted_ship)
      puts "The target is "+(intelligent_target ? "intelligent" : "random")
      require "pry"; binding.pry
      intended_target = intelligent_target if intelligent_target
    end
    intended_target
  end

  def analyze_shot(cell)
    if !cell.empty? && cell.ship.sunk?
      @ship_info.delete(cell.ship)
      @targetted_ship = nil
    elsif !cell.empty?
      @ship_info[cell.ship] << cell.coordinate
    end
  end
  #
  def remove_invalid_cells_string(board,available_cells)
    available_cells.select do |coord|
      board.cells[coord] != nil && !board.cells[coord].fired_upon?
    end
  end
  #
  def remove_invalid_cells_cell(available_cells)
    available_cells.select do |coord,cell|
      !cell.fired_upon?
    end
  end

  def find_consective(board,ship_key)
    adjacents = remove_invalid_cells_string(board,get_adjacents(board,ship_key))
    adjacents.find do |coordinate|
      #all_cells = @ship_info[ship_key]
      all_cells = @ship_info[ship_key].map{|cell|cell} #this is to prevent the all_cells from being set to the
      all_cells << coordinate #array object stored in the has.  It is horrible but a necessary evil.
      board.consecutive?(all_cells.sort) && !board.cells[coordinate].fired_upon?
    end
  end

  def get_adjacents(board,ship_key)
    @ship_info[ship_key].map do |cell|
      board.cells[cell].adjacent_cells.values
    end.flatten
  end
  #
  # def cells_on_axis(available_cells, index)
  #   available_cells.select do |cell|
  #     @last_hit.coordinate[index] == cell.coordinate[index]
  #   end
  # end
  #
  # def except(hash,keys) #I do not know why this isn't included with ruby
  #   keys.each do |k|
  #     hash.delete(k)
  #   end
  #   hash
  # end
  #
  # def determine_distance_between_cells(cell1,cell2,index)
  #   opp_axis_index = index #the opposite axis to the axis index
  #   cell_1_pos = cell1.coordinate[opp_axis_index]
  #   cell_2_pos = cell2.coordinate[opp_axis_index]
  #   if opp_axis_index == 0 #if this is true, it is looking at letters which need to be converted to nums
  #     cell_1_pos = cell_1_pos.ord
  #     cell_2_pos = cell_2_pos.ord
  #   else
  #     cell_1_pos = cell_1_pos.to_i
  #     cell_2_pos = cell_2_pos.to_i
  #   end
  #   (cell_1_pos - cell_2_pos).abs()
  # end
end
