# Helium::Dependency

Simple dependency inkjection for Ruby object.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helium-dependency'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install helium-dependency

## Usage

Simply include `Helium::Dependency` and then define the list of dependencies, together with a block to create default injection.
Injected value are already available when the default block is evaluated, so dependencies can reference each other.

```
class Bike
  include Helium::Dependency

  dependency(:wheel_size) { 26 }
  dependency(:wheels, public: true) { Array.new(2) { Wheel.new(size: wheel_size) } }
end

Bike.new(wheel_size: 20).wheels #=> [#Wheel(@size: 20), #Wheel(@size: 20)]
```

Injection happens in the class `new` method before `initialize` is called, so you can define your own initialization and use dependencies inside it.

```
class NamedBike < Bike
  def initialize(name)
    @name = "#{name} (#{wheels.map(&:size).join(', ')})"
  end

  attr_reader :name
end

NamedBike.new("Steven").name #=> "Steven (26, 26)"
NamedBike.new("Lil Steven", wheel_size: 16).name #=> "Lil Steven (16, 16)"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/helium-dependency. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Helium::Dependency project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/helium-dependency/blob/master/CODE_OF_CONDUCT.md).
