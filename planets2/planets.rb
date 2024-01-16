#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax Mon Jan 15 20:39:27 2024
# https://github.com/nonnax
require 'love2d'

# GConstant = 6.674 * (10 ^ -11)
G = 0.06675  # sim gravitational constant
$speed = 1
class Body
  attr_accessor :pos, :vel, :mass, :distance, :speed

  def initialize(name, distance, _eccentricity, _inclination, velocity, mass)
    angle = Math.random(0, 1) * 2 * Math::PI
    # -- Ensure counter-clockwise rotation in the inverted y-axis system
    # if angle < Math::PI
    #     angle = angle + Math::PI
    # else
    #     angle = angle - Math::PI
    # end
    @name = name
    @distance = distance
    @pos = Vec[distance * Math.cos(angle), distance * Math.sin(angle)]
    #ccw rotation
    @vel = Vec[velocity * Math.sin(angle), -velocity * Math.cos(angle)]
    @initvel = @vel.clone
    @mass = mass
    @rmin = 10 ^ 5
    @rmax = 0
    @trajectory = []
  end

  def applyForce(sun, dt)
     d = sun.pos - pos
     dist2 = d.mag2

     force = (G * sun.mass * mass) / (dist2)
     angle =  d.heading

     ax = force * Math.cos(angle) / mass
     ay = force * Math.sin(angle) / mass

     @vel += Vec[ax, ay] * (dt * $speed)
     @distance = d.mag
     move(dt)
     self
  end
  def move(dt)
     @pos += @vel * (dt * $speed)
     self
  end
  def x
    @pos.x
  end
  def y
    @pos.y
  end
end


