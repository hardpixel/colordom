# frozen_string_literal: true

begin
  RUBY_VERSION =~ /(\d+\.\d+)/
  require "colordom/#{$1}/colordom"
rescue LoadError
  require 'colordom/colordom'
end

require 'colordom/error'
require 'colordom/color'
require 'colordom/image'
require 'colordom/version'

# Module that extracts dominant colors from images
# using native extension implemented in Rust.
module Colordom
  class << self
    # Get dominant colors using histogram quantization.
    # @param path (see Image#initialize)
    # @param max_colors (see Image#histogram)
    # @return (see Image#histogram)
    # @raise (see Image#initialize)

    def histogram(path, max_colors = 5)
      image = Image.new(path)
      image.histogram(max_colors)
    end

    # Get dominant colors using median cut quantization.
    # @param path (see Image#initialize)
    # @param max_colors (see Image#mediancut)
    # @return (see Image#mediancut)
    # @raise (see Image#initialize)

    def mediancut(path, max_colors = 5)
      image = Image.new(path)
      image.mediancut(max_colors)
    end

    # Get dominant colors using k-means clustering.
    # @param path (see Image#initialize)
    # @param max_colors (see Image#kmeans)
    # @return (see Image#kmeans)
    # @raise (see Image#initialize)

    def kmeans(path, max_colors = 5)
      image = Image.new(path)
      image.kmeans(max_colors)
    end
  end
end
