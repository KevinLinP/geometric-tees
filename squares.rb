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
  iterations = 50
  iterations.times do |n|
    num_circles << 5 * n
  end

  num_circles.each_with_index do |num_circle, series|
    radius = series * 0.9

    (0...num_circle).each do |a|
      #change = Math.sin((a + (series * 100))/num_circle.to_f * 2*Math::PI) * 0.2 + 0.8
      x = Math.sin(a/num_circle.to_f * 2*Math::PI) * radius
      y = Math.cos(a/num_circle.to_f * 2*Math::PI) * radius

      root = 4.0

      hue = (a / (1.0 * num_circle)) * (360 * 1)
      #hue = hue % 360

      if (series % 2) == 0
        sin = Math.sin(a/num_circle.to_f * 2*Math::PI)
        
        root_sin = sin.abs ** (1/root)
        root_sin *= -1.0 if sin < 0
        x += root_sin

        hue = (hue + 180) % 360
      else
        cos = Math.cos(a/num_circle.to_f * 2*Math::PI)

        root_cos = cos.abs ** (1/root)
        root_cos *= -1.0 if cos < 0
        y += root_cos
      end

      color = "hsl(#{hue}, 100, 100)"

      rotation = (a / (-1.0 * num_circle)) * 360

      c.g.translate(x, y).rotate(rotation) do |g|
        g.styles stroke: 'white', stroke_width: 0.05, fill: color
        g.polygon [0,0, 1,0, 1,1, 0,1]
      end
    end
  end

end

rvg.draw.write('squares.png')
