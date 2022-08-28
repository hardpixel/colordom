# frozen_string_literal: true

require 'test_helper'

class ColordomTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Colordom::VERSION
  end

  def test_that_it_generates_histogram_palette
    result = ::Colordom.histogram(valid_image)
    assert_instance_of ::Colordom::Color, result.first
  end

  def test_that_it_generates_mediancut_palette
    result = ::Colordom.mediancut(valid_image)
    assert_instance_of ::Colordom::Color, result.first
  end

  def test_that_it_generates_kmeans_palette
    result = ::Colordom.kmeans(valid_image)
    assert_instance_of ::Colordom::Color, result.first
  end

  def test_that_it_raises_an_exception
    assert_raises ::Colordom::Error do
      ::Colordom.histogram(invalid_image)
    end
  end

  private

  def valid_image
    File.join(__dir__, 'fixtures/valid.jpg')
  end

  def invalid_image
    File.join(__dir__, 'fixtures/invalid.png')
  end
end
