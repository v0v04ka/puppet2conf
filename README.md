# Puppet2conf

Generate all related to your puppet module documentation in your confluence

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puppet2conf', github: 'https://github.com/v0v04ka/puppet2conf'
```

And then execute:

    $ bundle

## Usage

First, generate a configuration file located at `~/.puppet2conf.yml`:

```yaml
username: confluence-bot
password: MySecurePassword
url: https://confluence.mycompany.com
space: OpsSpace
ancestor: PuppetModules
```

then create a Rake task that looks like this:

```ruby
desc 'Generate documentation'
task :gendoc do
  require 'puppet2conf'
  doc_pusher = Puppet2conf::DocPusher.new
  doc_pusher.gendocs('module_name')
end
```

If you have lots of modules with the same Rakefile, you could parse out the module name from metadata:

```ruby
desc 'Generate documentation'
task :gendoc do
  require 'puppet2conf'
  require 'json'
  module_name = JSON.parse(File.read 'metadata.json')['name'].split('-')[1]
  doc_pusher = Puppet2conf::DocPusher.new
  doc_pusher.gendocs(module_name)
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
