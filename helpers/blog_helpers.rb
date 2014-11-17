def blog_post_body(post)
  content = File.open(post.source_file, 'r').read
  render_for_feed content
end

def render_for_feed(post)
  require 'kramdown'
  Kramdown::Document.new(post.gsub(/---(.|\n)*---/,'')).to_html
end

def blog_posts
  sitemap.resources.select{|p| p.url =~ /blog\/./}.sort{|p| p.data.date}
end

def blog_post_id(post)
  "tag:#{data.site.url.gsub("http://",'')},#{post.data.date}:#{post.data.uri}"
end

def blog_post_url(post)
  URI.join(data.site.url, post.url)
end
