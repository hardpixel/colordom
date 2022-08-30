# frozen_string_literal: true

module Colordom
  # Color object with RGB and HEX values implemented in Rust.
  class Color
    # @!method initialize(r, g, b)
    # A new instance of Color.
    # @return [Color]

    # @!attribute [r] r
    # Red color value.
    # @return [Integer]

    # @!attribute [r] g
    # Green color value.
    # @return [Integer]

    # @!attribute [r] b
    # Blue color value.
    # @return [Integer]

    # @!method rgb
    # @!parse [ruby] alias to_rgb rgb
    # Get the RGB representation of the color.
    # @return [Array<Integer>]

    # @!method hex
    # @!parse [ruby] alias to_hex hex
    # Get the hex representation of the color.
    # @return [String]

    # Compare with other color value.
    # @param other [Color, Array<Integer>, String]
    # @return [Boolean]

    def ==(other)
      case other
      when Array
        rgb == other
      when String
        hex == other
      when self.class
        rgb == other.rgb
      else
        false
      end
    end
  end
end
