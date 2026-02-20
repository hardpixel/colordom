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

  def test_histogram_handles_pngs_with_alpha_channels
    result = ::Colordom.histogram(alpha_png_image).map(&:hex)
    assert_equal ["#313D44", "#357CC0", "#43B649"], result
  end

  def test_that_it_generates_mediancut_palette
    result = ::Colordom.mediancut(valid_image)
    assert_instance_of ::Colordom::Color, result.first
  end

  def test_mediancut_handles_pngs_with_alpha_channels
    result = ::Colordom.mediancut(alpha_png_image).map(&:hex)
    assert_equal ["#347CC3", "#343C44", "#44B44C", "#3C5868", "#3C9CA8"], result
  end

  def test_that_it_generates_kmeans_palette
    result = ::Colordom.kmeans(valid_image)
    assert_instance_of ::Colordom::Color, result.first
  end

  def test_kmeans_handles_pngs_with_alpha_channels
    result = ::Colordom.kmeans(alpha_png_image)
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

  def alpha_png_image
    File.join(__dir__, 'fixtures/alpha.png')
  end
end
