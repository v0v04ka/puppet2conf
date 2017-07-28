require 'puppet2conf/version'
require 'strings2conf'
require 'md2conf'
require 'confluence/api/client'
require 'puppet-strings'
require 'yaml'

module Puppet2conf
  class GenDoc
    def initialize(username, password, url, space, ancestor)
      @username = username || nil
      @password = password || nil
      @url      = url || 'https://company.atlassian.net/wiki'
      @space    = space || 'Home'
      @ancestor = ancestor || nil
      @client   = Confluence::Api::Client.new(@username, @password, @url)
    end

    def push_page(page_title, html, ancestor)
      page = @client.get(spaceKey: @space, title: page_title)[0]
      if ancestor
        parent_page = @client.get(spaceKey: @space, title: ancestor)[0]
        if parent_page
          ancestors = [{ type: 'page', id: parent_page['id'] }]
        else
          warn "Couldn't find parent page #{ancestor}"
          exit 1
        end
      end
      if page.nil?
        puts "Page '#{page_title}' doesn't exist, creating it"
        @client.create(
          type:      'page',
          title:     page_title,
          space:     { key: @space },
          ancestors: ancestors,
          body:      { storage: { value: html, representation: 'storage' } }
        )
      else
        page = @client.get_by_id(page['id'])
        puts "Page '#{page_title}' exists. Updating it"
        version = page['version']['number'] || 1
        @client.update(
          age['id'],
          type:      'page',
          id:        page['id'],
          title:     page_title,
          space:     { key: @space },
          ancestors: ancestors,
          version:   { number: version + 1 },
          body:      { storage: { value: html, representation: 'storage' } }
        )
      end
    end

    def gendocs(module_name, path = './', pushstrings = false)
      module_html = Md2conf.parse_markdown File.read(path + 'README.md')
      push_page(module_name, module_html, @ancestor)
      Dir.glob(path + '*.md').each do |md_file|
        next if md_file.end_with? 'README.md'
        html       = Md2conf.parse_markdown File.read(md_file)
        page_title = "#{module_name} #{File.basename(md_file).sub('.md', '')}"
        push_page(page_title, html, module_name)
      end
      if pushstrings
        PuppetStrings.generate(PuppetStrings::DEFAULT_SEARCH_PATTERNS, json: "#{path}#{module_name}\
.json")
        reference_html = Strings2conf.convert(File.read("#{path}#{module_name}.json"))
        push_page("#{module_name} Reference", reference_html, module_name)
      end
    end
  end

  class DocPusher
    # Pass the following variables as parameters:
    # - username
    # - password
    # - url
    # - space
    # - ancestor
    #
    # or provide them in configuration file in YAML format.
    # Configuration file location can be overridden by `config_file` parameter.
    def initialize(config_file: '~/.puppet2conf.yaml', username: nil, password: nil, url: nil, space: nil, ancestor: nil)
      params = {
        'username' => username,
        'password' => password,
        'url'      => url,
        'space'    => space,
        'ancestor' => ancestor,
      }

      if File.file? File.expand_path(config_file)
        @config = YAML.load_file(File.expand_path(config_file))
      end

      @config.merge! params
      @client = Confluence::Api::Client.new(@config['username'], @config['password'], @config['url'])
    end

    def push_page(page_title, html, ancestor)
      page = @client.get(spaceKey: @config['space'], title: page_title)[0]
      if ancestor
        parent_page = @client.get(spaceKey: @config['space'], title: ancestor)[0]
        if parent_page
          ancestors = [{ type: 'page', id: parent_page['id'] }]
        else
          warn "Couldn't find parent page #{ancestor}"
          exit 1
        end
      end
      if page.nil?
        puts "Page '#{page_title}' doesn't exist, creating it"
        @client.create(
          type:      'page',
          title:     page_title,
          space:     { key: @config['space'] },
          ancestors: ancestors,
          body:      { storage: { value: html, representation: 'storage' } }
        )
      else
        page = @client.get_by_id(page['id'])
        puts "Page '#{page_title}' exists. Updating it"
        version = page['version']['number'] || 1
        @client.update(
          age['id'],
          type:      'page',
          id:        page['id'],
          title:     page_title,
          space:     { key: @config['space'] },
          ancestors: ancestors,
          version:   { number: version + 1 },
          body:      { storage: { value: html, representation: 'storage' } }
        )
      end
    end

    def self.gendocs(title_page, strings: true)
      module_html = Md2conf.parse_markdown File.read('README.md')
      push_page(title_page, module_html, @config['ancestor'])
      Dir.glob('*.md').each do |md_file|
        next if md_file.eql? 'README.md'
        html       = Md2conf.parse_markdown File.read(md_file)
        page_title = "#{title_page} #{File.basename(md_file).sub('.md', '')}"
        push_page(page_title, html, title_page)
      end
      if strings
        PuppetStrings.generate(PuppetStrings::DEFAULT_SEARCH_PATTERNS, json: "#{path}#{title_page}.json")
        reference_html = Strings2conf.convert(File.read("#{path}#{title_page}.json"))
        push_page("#{title_page} Reference", reference_html, title_page)
      end
    end
  end
end
