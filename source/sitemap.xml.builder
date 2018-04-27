xml.instruct!
xml.urlset 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  site_url = data.general.url
  xml.url do
    xml.loc site_url
    xml.lastmod blog.articles.first.date.to_time.iso8601
    xml.changefreq "daily"
    xml.priority "1.0"
  end
  xml.url do
    xml.loc URI.join(site_url, '/archives/')
    xml.lastmod blog.articles.first.date.to_time.iso8601
    xml.changefreq "daily"
    xml.priority "0.8"
  end
  xml.url do
    xml.loc URI.join(site_url, '/about/')
    xml.lastmod blog.articles.first.date.to_time.iso8601
    xml.changefreq "daily"
    xml.priority "0.8"
  end
  blog.articles.each do |article|
    xml.url do
      xml.loc URI.join(site_url, article.url)
      xml.lastmod article.date.to_time.iso8601
      xml.changefreq "never"
      xml.priority "0.8"
    end
  end
  blog.tags.each do |tag, articles|
    xml.url do
      xml.loc URI.join(site_url, URI.escape(tag_path(tag)))
      xml.lastmod (articles.size > 0 ? articles.first.date : Date.today).to_time.iso8601
      xml.changefreq "daily"
      xml.priority "0.5"
    end
  end
end
