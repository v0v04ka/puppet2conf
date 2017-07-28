require 'puppet2conf/version'
require 'strings2conf'
require 'md2conf'
require 'confluence/api/client'
require 'puppet-strings'
require 'yaml'

module Puppet2conf
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
      params             = {}
      params['username'] = username if username
      params['password'] = password if password
      params['url']      = url if url
      params['space']    = space if space
      params['ancestor'] = ancestor if ancestor

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
          page['id'],
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

    def gendocs(title_page, strings: true)
      module_html = Md2conf.parse_markdown File.read('README.md')
      push_page(title_page, module_html, @config['ancestor'])
      Dir.glob('*.md').each do |md_file|
        next if md_file.eql? 'README.md'
        html       = if md_file.eql? 'CHANGELOG.md'
          Md2conf.parse_markdown(File.read(md_file), max_toc_level: 2)
        else
          Md2conf.parse_markdown File.read(md_file)
        end
        page_title = "#{title_page} #{File.basename(md_file).sub('.md', '')}"
        push_page(page_title, html, title_page)
      end
      if strings
        PuppetStrings.generate(PuppetStrings::DEFAULT_SEARCH_PATTERNS, json: 'puppet_strings.json')
        reference_html = Strings2conf.convert(File.read('puppet_strings.json'))
        push_page("#{title_page} Reference", reference_html, title_page)
      end
    end
  end
end
