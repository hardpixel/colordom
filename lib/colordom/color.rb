# frozen_string_literal: true

module Colordom
  class Color
    def ==(other)
      self.class == other.class &&
        self.rgb == other.rgb
    end
  end
end
