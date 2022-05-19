require 'ffi'

require 'colordom/result'
require 'colordom/native'
require 'colordom/error'
require 'colordom/color'
require 'colordom/version'

module Colordom
  class << self
    def histogram(path, max_colors = 5)
      regex = /(\d+), (\d+), (\d+)/
      value = call(:to_histogram, path)

      parse(value, regex, max_colors)
    end

    def mediancut(path, max_colors = 5)
      regex = /r: (\d+), g: (\d+), b: (\d+)/
      value = call(:to_mediancut, path, max_colors)

      parse(value, regex, max_colors)
    end

    def kmeans(path, max_colors = 5)
      regex = /red: (\d+), green: (\d+), blue: (\d+)/
      value = call(:to_kmeans, path, max_colors)

      parse(value, regex)
    end

    private

    def call(method, path, *args)
      return if path.nil?

      result = Native.send(method, path, *args)
      result = result.read_string.force_encoding('UTF-8')

      raise Error, result if result.start_with?(Error.name)

      result
    end

    def parse(result, regex, limit = nil)
      return [] if result.nil?

      colors = result.scan(regex)
      colors = colors.first(limit) if limit && limit.positive?

      colors.map do |values|
        Color.new(*values)
      end
    end
  end
end
