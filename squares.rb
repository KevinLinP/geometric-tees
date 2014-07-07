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

  (-70...70).each do |x|
    (-100...100).each do |y|
      next if (x == 0) && (y == 0)

      if ((x % 2 == 0) && (y % 2 == 0))
        x_short, y_short = periodic_variant([x, y], 30, [0.9, 1.1])
        x_medium, y_medium = periodic_variant([x, y], 50, [1.1, 0.9])
        x_trans = x + (x_short * -0.7) + (x_medium * 1.25)
        y_trans = y + (y_short * 0.7) + (y_medium * -1.25)

        c.g.translate(x_trans, y_trans) do |g|
          g.styles stroke: 'black', stroke_width: 0.1, fill: 'white'
          g.polygon [0, 0, 1, 0, 1, 1, 0, 1]
        end
      end

    end
  end

end

rvg.draw.write('squares.png')
