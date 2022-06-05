require 'thermite/fiddle'

project_dir = File.dirname(File.dirname(__FILE__))

Thermite::Fiddle.load_module(
  'Init_colordom',
  cargo_project_path: project_dir,
  ruby_project_path: project_dir
)

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
