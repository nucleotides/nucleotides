activate :automatic_image_sizes
activate :directory_indexes

set :css_dir,      'stylesheets'
set :js_dir,       'javascripts'
set :images_dir,   'images'
set :partials_dir, 'partials'

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

# silence i18n warning
::I18n.config.enforce_available_locales = false

page "*",                  :layout => "layouts/default"
page "/benchmarks.html",   :layout => "layouts/scores"
page "/mailing-list.html", :layout => "layouts/mailing_list"
page "/atom.xml",          :layout => false
page "/",                  :layout => "layouts/index"

require "helpers/page_helpers"
require "helpers/voting_helpers"
helpers PageHelpers
helpers VotingHelpers
