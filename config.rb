Dotenv.load
Bundler.require
require './lib/middleman/renderers/custom'

###
# Blog settings
###

lang = 'en'
Time.zone = "Bucharest"
cname = 'mariusnedelcu.com'
set :site_url, "http://#{cname}"

activate :directory_indexes
activate :syntax
activate :livereload
# activate :minify_css

set :markdown_engine, :custom
set :markdown_engine_prefix, ::Middleman::Renderers
set :markdown,
  :fenced_code_blocks => true,
  :smartypants => true,
  :autolink => true,
  :tables => true,
  :with_toc_data => true,
  :no_intra_emphasis => true,
  :strikethrough => true,
  :underline => true,
  :highlight => true,
  :footnotes => true,
  :quote => true,
  :superscript => true

set :partials_dir, 'partials'

activate :blog do |blog|
  blog.permalink = "{title}/index.html"
  blog.sources = "articles/{year}-{month}-{day}-{title}.html"
  blog.taglink = "articles/{tag}/index.html"
  blog.layout = "wrk"
  blog.summary_separator = /(READMORE)/
  blog.summary_length = 500
  blog.year_link = "{year}/index.html"
  blog.month_link = "{year}/{month}/index.html"
  blog.day_link = "{year}/{month}/{day}/index.html"
  blog.default_extension = ".md"
  blog.tag_template = "tag.html"
  blog.paginate = true
  blog.per_page = 1
  blog.page_link = "p{num}"
end

activate :similar, :algorithm => :'word_frequency/tree_tagger'

page "/feed.xml",    layout: false
page "/sitemap.xml", layout: false
page "/404.html",    directory_index: false

require 'slim'
require 'sass'
require 'coffee-script'

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

compass_config do |config|
  config.output_style = :compact
end

ready do
  ::Middleman::Renderers::MiddlemanRedcarpetHTML.middleman_app = self
  sprockets.append_path '/lib/javascripts/'
  sprockets.append_path '/lib/stylesheets/'

  def redirect_to path, res
    proxy path, 'redirect.html', locals: { url: res.url }, layout: false
  end

end

configure :development do
 # activate :google_analytics do |ga|
  #  ga.tracking_id = 'UA-XXXXXX-YY'
  #end
end

activate :ogp do |ogp|
  ogp.namespaces = {
    fb: data.send(lang).ogp.fb,
    og: data.send(lang).ogp.og,
    twitter: data.send(lang).ogp.twitter
  }
  ogp.blog = true
  ogp.base_url = "http://#{cname}/"
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash, ignore: [
    'images'
  ]
  ignore '.DS_Store'
  ignore '.*.swp'
  ignore '_drafts'
  ignore 'redirect.html'
  activate :favicon_maker, :icons => {
    "favicon-hires.png" => [
      { icon: "apple-touch-icon-152x152-precomposed.png" },
      { icon: "apple-touch-icon-144x144-precomposed.png" },
      { icon: "apple-touch-icon-120x120-precomposed.png" },
      { icon: "apple-touch-icon-114x114-precomposed.png" },
      { icon: "apple-touch-icon-76x76-precomposed.png" },
      { icon: "apple-touch-icon-72x72-precomposed.png" },
      { icon: "apple-touch-icon-60x60-precomposed.png" },
      { icon: "apple-touch-icon-57x57-precomposed.png" },
      { icon: "apple-touch-icon-precomposed.png", size: "57x57" },
      { icon: "apple-touch-icon.png", size: "57x57" },
      { icon: "favicon-196x196.png" },
      { icon: "favicon-160x160.png" },
      { icon: "favicon-96x96.png" },
      { icon: "mstile-144x144", format: "png" }
    ],
    "favicon-lores.png" => [
      { icon: "favicon-32x32.png" },
      { icon: "favicon-16x16.png" },
      { icon: "favicon.png", size: "16x16" },
      { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" }
    ]
  }
end

# activate :disqus do |d|
#   d.shortname = lang == :en ? "ngsio" : "jangsio"
# end

activate :deploy do |deploy|
  IO.write "source/CNAME", cname
  deploy.method = :git
  deploy.branch = 'gh-pages'
  # deploy.remote = "https://#{ENV['GH_TOKEN']}@github.com/nebulae2016/#{cname}.git"
  deploy.remote = "git@github.com:nedzen/mariusnedelcu.com.git"
end

helpers do

  def is_page_active(page)
    current_page.url == page ? 'active' : ''
  end

  def alt_href
    "http://#{alt_host}#{current_resource.url}"
  end

  def alt_link
    link_to %Q{#{alt_lang_name}},
      alt_href, href_lang: alt_lang, rel: "alternate", title: "read in #{alt_lang_longname}"
  end

end
