# frozen_string_literal: true

module Colordom
  # Image object implemented in Rust that extracts dominant colors.
  class Image
    # @!method initialize(path)
    # A new instance of Image.
    # @param path [String, Pathname, File]
    # @return [Image]
    # @raise [Error] if path is not a valid image

    # @!method histogram(max_colors)
    # Get dominant colors using histogram quantization.
    # @param max_colors [Integer]
    # @return [Array<Color>]

    # @!method mediancut(max_colors)
    # Get dominant colors using median cut quantization.
    # @param max_colors [Integer]
    # @return [Array<Color>]

    # @!method kmeans(max_colors)
    # Get dominant colors using k-means clustering.
    # @param max_colors [Integer]
    # @return [Array<Color>]
  end
end
