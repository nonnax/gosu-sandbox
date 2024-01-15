#!/usr/bin/env ruby
# Id$ nonnax Mon Jan 15 17:37:01 2024
# https://github.com/nonnax
# $:<<'../lib'
require 'gosu'
require 'love2d'
require_relative 'planets'

Color = Gosu::Color
class Game < Gosu::Window

  SCREEN_HEIGHT = 1000
  SCREEN_WIDTH = 1000

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
  end

  def draw
  end

  def update
  end

end

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
  # G = 6.67430e-11  # Gravitational constant
  SCALE_FACTOR = 1e-9  # Scale down the distances for better visualization
  INITIAL_ZOOM = 1.0
  ZOOM_STEP = 0.1
  attr_accessor :planets
  def initialize
    super(800, 800)
    self.caption = 'Solar System Simulation'

    # @sun = CelestialBody.new(width / 2, height / 2, 1.989e30, [0, 0])  # Sun
    # @earth = CelestialBody.new(150, 0, 5.972e24, [0, -29_783.34])  # Earth
    @font = Gosu::Font.new(9)
    @zoom = INITIAL_ZOOM
    @sun = Body.new('Sun', 0, 0, 0, 0, 1_989_000) #-- Sun
    @planets = []
    # -- Define planets in our solar system with realistic initial conditions
    # -- semi-major axis, eccentricity, inclination
    planets.push Body.new('Mercury', 57.9, 0, 0, 47.87, 0.055)
    planets.push Body.new('Venus', 108.2, 0, 0, 35.02, 0.815)
    planets.push Body.new('Earth', 149.6, 0, 0, 29.78, 1)
    planets.push Body.new('Mars', 227.9, 0, 0, 24.077, 0.107)
    planets.push Body.new('Jupiter', 778.3, 0, 0, 13.07, 317.8)
    planets.push Body.new('Saturn', 1427.0, 0, 0, 9.68, 95.16)
    planets.push Body.new('Uranus', 2871.0, 0, 0, 6.81, 14.54)
    planets.push Body.new('Neptune', 4497.1, 0, 0, 5.43, 17.15)

    planets.each do |planet|
      p planet
    end

  end

  def update
    # calculate_gravity(@earth, @sun)
    # p [@earth]
    # update_position(@earth)
    @planets.map! do |planet|
      planet.applyForce(@sun, dt)
    end
  end

  def draw
    translate(width / 2, height / 2) do
      scale(@zoom, @zoom) do
        draw_circle(@sun.pos.x, @sun.pos.y, 40, Color::YELLOW)
        @planets.each do |planet|
          draw_circle(planet.pos.x, planet.pos.y, 10, Color::BLUE)
          line(0, 0, planet.pos.x, planet.pos.y)
          circle(0, 0, planet.distance, Color::CHARCOAL)
          print(planet.distance.round(2), planet.pos.x, planet.pos.y)
        end
      end
    end
  end

  def button_down(id)
    case id
    when Gosu::KB_UP
      @zoom += ZOOM_STEP
    when Gosu::KB_DOWN
      @zoom -= ZOOM_STEP
      @zoom = [0.085, @zoom].max  # Ensure zoom doesn't go below 10%
    when Gosu::KB_ESCAPE
      close!
    when 87 # kp+
      $speed +=0.5
    when 86 # kp-
      $speed -=0.5
    when 98 # kp-enter
      $speed =0
    end
    p id
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
    body.x *= 10**-5 * dt
    body.y *= 10**-5 * dt
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

end

SolarSystemSimulation.new.show
