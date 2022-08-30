# frozen_string_literal: true

module Colordom
  class Color
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
