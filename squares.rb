require 'rvg/rvg'
include Magick
include Math

RVG::dpi = 300

def periodic_variant(coordinate, period, multipliers)
  x, y = coordinate
  x_multiplier, y_multiplier = multipliers

  x_variant = Math.sin(((x * x_multiplier) + (y * y_multiplier))/period.to_f * 2*Math::PI)
  y_variant = Math.sin(((x * x_multiplier) + (y * y_multiplier))/period.to_f * 2*Math::PI)

  [x_variant, y_variant]
end

rvg = RVG.new(10.in, 16.in).viewbox(-50, -80, 100, 160) do |c|
  c.background_fill = 'white'

  num_circles = []
  20.times do |n|
    num_circles << 20 * n
  end

  num_circles.each_with_index do |num_circle, series|
    last_circle_index = num_circle - 1
    a = num_circle - 1
    diameter = series * 1

    (0..last_circle_index).each do |a|
      change = Math.sin((a + (series * 100))/num_circle.to_f * 2*Math::PI) * 0.2 + 0.8
      x = Math.sin(a/num_circle.to_f * 2*Math::PI) * diameter * change
      y = Math.cos(a/num_circle.to_f * 2*Math::PI) * diameter * change

      c.g.translate(x, y) do |g|
        g.styles stroke: 'black', stroke_width: 0.1, fill: 'white'
        g.polygon [0,0, 1,0, 1,1, 0,1]
      end
    end
  end

end

rvg.draw.write('squares.png')
