class Cell
  attr_reader :coordinate, :ship, :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def fired_upon?
    @fired_upon
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    if !empty?
      @ship.hit
    end
    @fired_upon = true
  end
  def adjacent_cells
    cell = @coordinate
    {
      up: (cell[0].ord - 1).chr + cell[1],
      down: (cell[0].ord + 1).chr + cell[1],
      left: cell[0] + (cell[1].to_i - 1).to_s,
      right: cell[0] + (cell[1].to_i + 1).to_s
    }
end

  def render(render_ships = false)
    if empty? && fired_upon?
      "M"
    elsif empty?
      "."
    elsif @ship.sunk?
      "X"
    elsif fired_upon?
      "H"
    elsif render_ships
      "S"
    else
      "."
    end
  end
end
