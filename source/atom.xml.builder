xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title data.site.title
  xml.id data.site.url
  xml.link({href: data.site.url})
  xml.link({href: URI.join(data.site.url, data.site.feed), rel: "self", type: "application/atom+xml" })
  xml.author do |author|
    author.name  data.site.author.name
    author.email data.site.author.email
    author.uri   data.site.author.uri
  end
  xml.updated blog_posts.first.data.date.to_time.iso8601

  blog_posts.each do |post|
    xml.entry do
       xml.title post.data.title
       xml.id blog_post_id(post)
       xml.link({rel: "alternate", href: blog_post_url(post)})
       xml.published post.data.date.to_time.iso8601
       xml.updated post.data.date.to_time.iso8601
       xml.author do |author|
         author.name  data.site.author.name
         author.email data.site.author.email
         author.uri   data.site.author.uri
       end
       xml.content({type: "html"}, blog_post_body(post))
    end
  end
end
