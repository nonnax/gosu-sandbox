#!/usr/bin/env ruby
# Id$ nonnax Tue Jan 16 00:31:33 2024
# https://github.com/nonnax
$:<<'../lib'
require 'gosu'
require 'love2d'

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

class GameWindow < Gosu::Window
  def initialize
    super(800, 600, false)
    self.caption = 'Rotating Circles at Different Velocities'

    @center_x = 400
    @center_y = 300
    @moving_radius = 100
    @circle_count = 10
    @font = Gosu::Font.new(12)
    # Initialize an array to store rotating circles
    @rotating_circles = []
    initialize_rotating_circles
  end

  def initialize_rotating_circles
    @circle_count.times do |i|
      radius = Math.random(2, 10) #+ i * 20
      speed = 1 + i * Math.random(0.5, 5)  # Adjust the speed of rotation for each circle

      @rotating_circles << {
        radius: radius,
        orbit: Math.random(20, 280),
        speed: speed,
        angle: Math.random(0, Math::PI*2),
      }
    end
  end

  def update
    @rotating_circles.each do |circle|
      circle[:angle] += circle[:speed]*dt
      angle_in_radians = -circle[:angle].to_rad

      moving_circle_position = Vector.new(@center_x + circle[:orbit] * Math.cos(angle_in_radians),
                                          @center_y + circle[:orbit] * Math.sin(angle_in_radians))

      rotating_circle_position = moving_circle_position + Vector.new(circle[:radius], 0).rotate(angle_in_radians)

      # circle[:x] = rotating_circle_position.x
      # circle[:y] = rotating_circle_position.y
      circle[:pos]=Vec[rotating_circle_position.x, rotating_circle_position.y]
    end
  end

  def draw
    draw_circle(@center_x, @center_y, @moving_radius/2, Gosu::Color::YELLOW)

    @rotating_circles.each do |circle|
      # d = Vec[circle[:x], circle[:y]]
      pos = circle[:pos]
      sun = Vec[@center_x, @center_y]
      dist = pos.dist(sun)
      draw_circle(pos.x, pos.y, circle[:radius], Gosu::Color::RED)
      draw_circle(@center_x, @center_y, dist, Color::CHARCOAL)
      line(sun.x, sun.y, pos.x, pos.y, Color::CHARCOAL)
      line(pos.x, sun.y, pos.x, pos.y, Color::CHARCOAL)
      line(sun.x, sun.y, pos.x, sun.y, Color::CHARCOAL)
      # line(sun.x, pos.y, pos.x, pos.y, Color::CHARCOAL)
      # line(sun.x, sun.y, sun.x, pos.y, Color::BLUE)
      print(pos.mag.round, pos.x, pos.y)
    end
  end

  def button_down(id)
    if id==Gosu::KB_ESCAPE then  exit end
  end

  private

  def draw_circle(x, y, radius, color)
    segments = 30
    angle_increment = 360.0 / segments

    segments.times do |i|
      angle = i * angle_increment
      x1 = x + radius * Math.cos(angle.to_rad)
      y1 = y + radius * Math.sin(angle.to_rad)

      angle = (i + 1) * angle_increment
      x2 = x + radius * Math.cos(angle.to_rad)
      y2 = y + radius * Math.sin(angle.to_rad)

      draw_line(x1, y1, color, x2, y2, color, 0)
    end
  end
end

class Numeric
  def to_rad
    self * Math::PI / 180
  end
end

class Vector
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Vector.new(@x + other.x, @y + other.y)
  end

  def rotate(angle_in_radians)
    x_new = @x * Math.cos(angle_in_radians) - @y * Math.sin(angle_in_radians)
    y_new = @x * Math.sin(angle_in_radians) + @y * Math.cos(angle_in_radians)
    Vector.new(x_new, y_new)
  end
end

window = GameWindow.new
window.show

