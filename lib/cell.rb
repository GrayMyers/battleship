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

  def render(render_ships = false)
    if empty? && fired_upon?
      "M"
    elsif empty? && !fired_upon?
      "."
    elsif @ship.sunk?
      "X"
    elsif fired_upon?
      "H"
    else
      if render_ships
        "S"
      else
        "."
      end 
    end
  end
end
