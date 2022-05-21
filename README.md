# Colordom

Ruby gem to extract dominant colors from images using native extension implemented in Rust. Rust must be available on your system to install this gem.

[![Gem Version](https://badge.fury.io/rb/colordom.svg)](https://badge.fury.io/rb/colordom)
[![Build](https://github.com/hardpixel/colordom/actions/workflows/build.yml/badge.svg)](https://github.com/hardpixel/colordom/actions/workflows/build.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/6040c6d79abf2d6e7efb/maintainability)](https://codeclimate.com/github/hardpixel/colordom/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'colordom'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install colordom

## Usage

```ruby
require 'colordom'

# Get colors using histogram algorithm
Colordom.histogram(image_path)

# Get colors using median cut algorithm
Colordom.mediancut(image_path)

# Get colors using kmeans algorithm
Colordom.kmeans(image_path)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hardpixel/colordom.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
