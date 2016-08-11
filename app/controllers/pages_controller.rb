class PagesController < ApplicationController
  # GET '/'
  def index # => render
    content = <<-HTML
      <form action="/" method="POST">
        <input type="hidden" name="authenticity_token" value="#{form_authenticity_token}"></input>
        <input type="text" name="name" placeholder="page name"><br>
        <textarea rows="50" cols="50" name="content" placeholder="content" ></textarea><br>
        <input type="text" name="tags" placeholder="tags (comma separated"><br>
        <input type="submit" value="create page">
      </form>
    HTML
    render html: html_boiler_with_content(content).html_safe
  end

  # POST '/'
  def create # => render
    name, content, tags = parse_params
    created_file_string = create_markdown_file_in_blog(name, content, tags)
    response_html = <<-HTML
      <b>File name</b>: #{name}<br>
      <b>Markdown content</b>:<br>
      <pre>#{created_file_string}</pre><br>
    HTML
    require 'byebug'
    compile_blog
    deploy_blog
    render html: html_boiler_with_content(response_html).html_safe
  end

  private
  def parse_params # => array
    params.values_at(:name, :content, :tags)
  end
  def separate_metadata_and_convert_to_html(created_file_string) # => array
    
  end
  def create_markdown_file_in_blog(name, content, tags) # # => string of markdown file
    tags_formatted = tags.split(", ").map do |tag|
      ":#{tag}"
    end.join(",")
    cmd = <<-RB
      require('./seed')
      Seed.create(name: '#{name}', content: '#{content}',tags: [#{tags_formatted}].map(&:to_s) )
    RB
    `cd blog && ruby -e "#{cmd}"`
    File.read("./blog/source/markdown/#{name}.md.erb")
  end
  def compile_blog # => self
    `cd blog && bundle exec ruby gen.rb`
    self
  end
  def deploy_blog # => self
    `cd blog && git add -A`
    `cd blog && git add -u`
    `cd blog && git commit -m 'update from add-blog-page'`
    `cd blog && sh push_dist_to_gh_pages`
    self
  end
  def html_boiler_with_content(content) # => string
    <<-HTML
      <!doctype html>
      <html lang='en'>
      <head><title>add-page-to-blog</title></head>
      <body>
        #{content}
      </body>
      </html>
    HTML
  end

end
