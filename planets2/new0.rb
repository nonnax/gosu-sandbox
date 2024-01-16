#!/usr/bin/env ruby
# Id$ nonnax Mon Jan 15 17:24:29 2024
# https://github.com/nonnax
$:<< '../lib'
require 'gosu'
require 'love'

require 'gosu'

class CelestialBody
  attr_accessor :x, :y, :mass, :velocity

  def initialize(x, y, mass, velocity)
    @x = x
    @y = y
    @mass = mass
    @velocity = velocity
  end
end

class SolarSystemSimulation < Gosu::Window
  G = 6.67430e-11  # Gravitational constant
  SCALE_FACTOR = 1e-9  # Scale down the distances for better visualization
  SCALE_DOWN = 1.5  # Scale down the entire canvas by 50%

  def initialize
    super((800*1.5).to_i, (800*1.5).to_i)
    self.caption = 'Solar System Simulation'

    @sun = CelestialBody.new(width / 2, height / 2, 1.989e30, [0, 0])  # Sun
    @earth = CelestialBody.new(width / 2 + 150, height / 2, 5.972e24, [0, -29_783.34])  # Earth
  end

  def update
    calculate_gravity(@earth, @sun)
    update_position(@earth)
  end

  def draw
    draw_circle(@sun.x, @sun.y, 40, Gosu::Color::YELLOW)
    draw_circle(@earth.x, @earth.y, 10, Gosu::Color::BLUE)
  end

  private

  def calculate_gravity(body1, body2)
    dx = body2.x - body1.x
    dy = body2.y - body1.y
    distance_squared = dx**2 + dy**2
    distance = Math.sqrt(distance_squared)

    force_magnitude = (G * body1.mass * body2.mass) / distance_squared
    force_x = force_magnitude * (dx / distance)
    force_y = force_magnitude * (dy / distance)

    body1.velocity[0] += force_x / body1.mass
    body1.velocity[1] += force_y / body1.mass
  end

  def update_position(body)
    body.x += body.velocity[0] * SCALE_FACTOR
    body.y += body.velocity[1] * SCALE_FACTOR
  end

  def draw_circle(x, y, radius, color)
    segments = 20

    angle_increment = 360.0 / segments

    segments.times do |i|
      angle = Gosu.radians(i * angle_increment)
      x1 = x + radius * Math.cos(angle)
      y1 = y + radius * Math.sin(angle)

      angle = Gosu.radians((i + 1) * angle_increment)
      x2 = x + radius * Math.cos(angle)
      y2 = y + radius * Math.sin(angle)

      draw_line(x1, y1, color, x2, y2, color, z = 0)
    end
  end
  def button_down(id)
    if id==Gosu::KB_ESCAPE then  exit end
  end

end

SolarSystemSimulation.new.show
