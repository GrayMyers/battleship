require "Minitest/autorun"
require "Minitest/pride"
require "./lib/ship.rb"

class ShipTest < Minitest::Test

  def setup
    @ship = Ship.new("Cruiser",3)
  end

  def test_it_exists
    assert_instance_of Ship, @ship
  end

  def test_attributes
    assert_equal "Cruiser", @ship.name
    assert_equal 3, @ship.length
    assert_equal 3, @ship.health
  end

  def test_sunk
    assert_equal false, @ship.sunk?
  end

end
