require "puppet2conf/version"
require 'strings2conf'
require 'md2conf'
require 'confluence/api/client'
require 'puppet-strings'

module Puppet2conf
  class GenDoc
    def initialize(username,
                   password,
                   url,
                   space,
                   ancestor)
      @username = username || nil
      @password = password || nil
      @url      = url || 'https://confluence.iponweb.net'
      @space    = space || 'OPS'
      @ancestor = ancestor || 'Modules'
      @client   = Confluence::Api::Client.new(@username, @password, @url)
    end

    def push_page(page_title, html, ancestor)
      page = @client.get({spaceKey: @space, title: page_title})[0]
      if ancestor
        parent_page = @client.get({spaceKey: @space, title: ancestor})[0]
        if ancestor
          ancestors = [{type: 'page', id: parent_page['id']}]
        else
          warn "Couldn't find parrent page #{ancestor}"
          exit 1
        end
      end
      if page
        @client.update(page['id'],
                       {type:      "page",
                        title:     "title",
                        space:     {key: space},
                        ancestors: ancestors,
                        body:      {storage: {value: html, representation: "storage"}}})
      else
        @client.create({type:      "page",
                        title:     "title",
                        space:     {key: space},
                        ancestors: ancestors,
                        body:      {storage: {value: html, representation: "storage"}}})
      end
    end


    def gendocs(module_name, path='./')
      module_html = Md2conf.parse_markdown File.read(path + 'README.md')
      push_page(module_name, module_html, @ancestor)
      ["CHANGELOG.md", "CONTRIBUTING.md"].each do |md_file|
        if File.exist?(path + md_file)
          html       = Md2conf.parse_markdown File.read(path + md_file)
          page_title = "#{module_name} #{md_file.sub('.md', '')}"
          push_page(page_title, html, module_name)
        end
      end
      PuppetStrings.generate(nil, :json => "#{path}#{module_name}.json")
      reference_html = Strings2conf.convert(File.read("#{path}#{module_name}.json"))
      push_page("#{module_name} Reference", reference_html, module_name)
    end

  end
end
