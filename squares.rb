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
  16.times do |n|
    num_circles << 20 * n
  end

  num_circles.each_with_index do |num_circle, series|
    radius = series * 1

    (0...num_circle).each do |a|
      #change = Math.sin((a + (series * 100))/num_circle.to_f * 2*Math::PI) * 0.2 + 0.8
      x = Math.sin(a/num_circle.to_f * 2*Math::PI) * radius
      y = Math.cos(a/num_circle.to_f * 2*Math::PI) * radius

      skew_factor = 1.0 * 2
      x += Math.sin(a/num_circle.to_f * 2*Math::PI) * ((series % 2)/skew_factor)
      y += Math.cos(a/num_circle.to_f * 2*Math::PI) * (((series + 1) % 2)/skew_factor)

      c.g.translate(x, y) do |g|
        g.styles stroke: 'black', stroke_width: 0.1, fill: 'white'
        g.polygon [0,0, 1,0, 1,1, 0,1]
      end
    end
  end

end

rvg.draw.write('squares.png')
