module Colordom
  class Color
    attr_reader :r, :g, :b

    def initialize(red, green, blue)
      @r, @g, @b = [red, green, blue].map(&:to_i)
    end

    def ==(other)
      other.is_a?(self.class) &&
        rgb == other.rgb
    end

    def rgb
      [r, g, b]
    end

    def hex
      '#%02X%02X%02X' % rgb
    end

    alias to_rgb rgb
    alias to_hex hex
  end
end
