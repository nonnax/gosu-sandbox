#!/usr/bin/env ruby
# Id$ nonnax Mon Jan 15 17:37:01 2024
# https://github.com/nonnax
# $:<<'../lib'
require 'gosu'
require 'love2d'
require_relative 'planets'

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

    @font = Gosu::Font.new(9)
    @zoom = INITIAL_ZOOM
    @sun = Body.new('Sun', 0, 0, 0, 0, 1_989_000) #-- Sun
    createPlanets
    planets.each do |planet|
      p planet
    end
    p Color.constants
  end

  def createPlanets
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
  end

  def update
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
          line(0, 0, planet.pos.x, planet.pos.y, Color::CHARCOAL)
          circle(0, 0, planet.pos.mag, Color::CHARCOAL)
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
    when Gosu::KB_R
      #reset sim to initial values
      $speed = 1
      createPlanets
    when 87 # kp+
      $speed +=0.5
    when 86 # kp-
      $speed -=0.5
    when 89 # kp1
      $speed = 1
    when 90 # kp1
      $speed = 2
    when 98 # kp-enter
      $speed = 0
    end
    p id
  end

end

SolarSystemSimulation.new.show
