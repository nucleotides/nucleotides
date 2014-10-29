def blog_post_url(post)
  URI.join(data.site.url, "blog/", post.url)
end

def blog_post_body(post)
  resource = sitemap.find_resource_by_path("blog/#{post.url}.html")
  content  = File.open(resource.source_file, 'r').read
  render_for_feed content
end

def render_for_feed(post)
  require 'kramdown'
  Kramdown::Document.new(post.gsub(/---(.|\n)*---/,'')).to_html
end

def blog_post_id(post)
  "tag:#{data.site.url.gsub("http://",'')},#{post.date}:#{post.uri}"
end

def blog_post_date(post)
  post.date.to_time.iso8601
end

