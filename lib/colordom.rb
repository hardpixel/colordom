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

module Colordom
  class << self
    def histogram(path, max_colors = 5)
      call(:histogram, path, max_colors)
    end

    def mediancut(path, max_colors = 5)
      call(:mediancut, path, max_colors)
    end

    def kmeans(path, max_colors = 5)
      call(:kmeans, path, max_colors)
    end

    private

    def call(method, path, *args)
      return if path.nil?

      image = Image.new(path)
      image.send(method, *args)
    end
  end
end
