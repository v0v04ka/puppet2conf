# Puppet2conf

Generate all related to your puppet module documentation in your confluence

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puppet2conf', github: 'https://github.com/v0v04ka/puppet2conf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet2conf

## Usage
For example add following to your Rakefile in puppet module for complete documentation generation (including puppet strings generate)
```ruby
require 'puppet2conf'
task :gendoc do
  puppet2conf = Puppet2conf::GenDoc.new('confluence-bot-name',
                                        'confluencePasswd4Bot',
                                        'https://confluence.example.net',
                                        'OPS',
                                        'Modules')
  puppet2conf.gendocs('module_name', './', true)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/v0v04ka/puppet2conf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Puppet2conf project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/v0v04ka/puppet2conf/blob/master/CODE_OF_CONDUCT.md).
