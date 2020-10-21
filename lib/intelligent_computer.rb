class IntelligentComputer

  def initialize(user_board,computer_board)
    @user_board = user_board
    @computer_board = computer_board
  end

  def select_target
    if @last_hit && !@direction
      #hit a ship last turn but doesn't know which direction it is facing
      available_cells = remove_invalid_cells_string(@last_hit.adjacent_cells).values


    elsif @last_hit
      #knows ship and direction
      if @direction == :x
        aligned = except(@last_hit.adjacent_cells,[:up,:down])
      else
        aligned = except(@last_hit.adjacent_cells,[:left,:right])
      end
      available_cells = remove_invalid_cells_string(aligned).values

    else
      #knows no locations of ships
      available_cells = remove_invalid_cells_cell(@user_board.cells).keys
    end


    if !available_cells || available_cells.length == 0
      if @direction == :x
        index = 0
      else
        index = 1
      end

      all_available = remove_invalid_cells_cell(@user_board.cells).values
      available_cells = [cells_on_axis(all_available,index).min_by do |cell|
        #find cell which is the closest to the last shot
        determine_distance_between_cells(cell,@last_hit,index)
      end.coordinate]
    end
    available_cells.sample

  end

  def analyze_hit(cell)
    if @last_hit && !@direction
      if @last_hit.coordinate[0] == cell[0]
        @direction = :x
      else
        @direction = :y
      end
    end
    @last_hit = @user_board.cells[cell]
  end

  def analyze_sunk
    @direction = nil
  end

  def remove_invalid_cells_string(available_cells)
    available_cells.select do |direction, coord|
      @user_board.cells[coord] != nil && !@user_board.cells[coord].fired_upon?
    end
  end

  def remove_invalid_cells_cell(available_cells)
    available_cells.select do |coord, cell|
      !cell.fired_upon?
    end
  end

  def cells_on_axis(available_cells, index)
    available_cells.select do |cell|
      @last_hit.coordinate[index] == cell.coordinate[index]
    end
  end

  def except(hash,keys) #I do not know why this isn't included with ruby
    keys.each do |k|
      hash.delete(k)
    end
    hash
  end

  def determine_distance_between_cells(cell1,cell2,index)
    opp_axis_index = index #the opposite axis to the axis index
    cell_1_pos = cell1.coordinate[opp_axis_index]
    cell_2_pos = cell2.coordinate[opp_axis_index]
    if opp_axis_index == 0 #if this is true, it is looking at letters which need to be converted to nums
      cell_1_pos = cell_1_pos.ord
      cell_2_pos = cell_2_pos.ord
    else
      cell_1_pos = cell_1_pos.to_i
      cell_2_pos = cell_2_pos.to_i
    end
    (cell_1_pos - cell_2_pos).abs()
  end
end
