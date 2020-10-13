class Cell
  attr_reader :coordinate, :ship, :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    @fired_upon = false
  end

  def fired_upon?
    @fired_upon
  end

  def empty?
    @ship == nil
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

  def render(render_ships = false)
    if fired_upon? && empty?
      "M"
    elsif !fired_upon? && empty?
      "."
    elsif fired_upon? && !empty?
      if @ship.sunk?
        "X"
      else
        "H"
      end
    elsif !fired_upon? && !empty?
      if render_ships
        "S"
      else
        "."
      end
    end
  end

end
