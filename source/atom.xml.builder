xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.site_url data.site.url
  xml.title data.site.title
  xml.link({href: data.site.url})
  xml.link({href: URI.join(data.site.url, data.site.feed), rel: "self"})
  xml.author do |author|
    author.name  data.site.author.name
    author.email data.site.author.email
    author.uri   data.site.author.uri
  end
  xml.updated data.posts.first.date.to_time.iso8601

  data.posts.each do |post|
    xml.entry do
       xml.title post.name
       xml.link({rel: "alternate", href: URI.join(data.site.url, "blog/", post.url)})
       xml.published post.date.to_time.iso8601
       xml.updated post.date.to_time.iso8601
       xml.author do |author|
         author.name  data.site.author.name
         author.email data.site.author.email
         author.uri   data.site.author.uri
       end
    end
  end
end
