# HashEx

1. `HashEx::JsObject` - JavaScript-Object-like hash.
1. `HashEx::Base` - Abstract base class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'HashEx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install HashEx

## Usage

### `HashEx::Base`

Just override `HashEx::Base#convert_key` to create your own one

### `HashEx::JsObject`

It works like JS Object. For an instance `h`:

1. `h[:key]`, `h['key']` and `h.key` are equal.
1. `h.a = { foo: { bar: { baz: 123} } }` will convert `Hash` to `HashEx::JsObject` recursively. `h.a.foo` and `h.a.foo.bar` will be instances of `HashEx::JsObject`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eGust/HashEx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
