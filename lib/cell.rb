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

end
