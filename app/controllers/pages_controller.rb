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
    created_file = create_markdown_file_in_blog(name, content, tags)
    compile_blog
    deploy_blog
    render json: created_file.to_json
  end

  private
  def parse_params # => array
    params.values_at(:name, :content, :tags)
  end
  def create_markdown_file_in_blog(name, content, tags) # # => hash
    tags_formatted = tags.split(", ").map { |tag| %{"#{tag}"} }
    cmd = <<-RB
      require('./seed')
      Seed.create(name: "#{name}", content: "#{content}",tags: #{tags_formatted} )
    RB
    require 'byebug'
    byebug
    `cd blog && ruby -e "#{cmd}"`
    { result: File.read("./blog/source/markdown/#{name}.md.erb") }
  end
  def compile_blog # => self
    `cd blog && ruby gen.rb`
    self
  end
  def deploy_blog # => self
    `cd blog && sh push_dist_to_github_pages`
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
