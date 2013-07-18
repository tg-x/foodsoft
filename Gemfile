# A sample Gemfile
source "https://rubygems.org"
ruby "2.0.0"

gem "rails", '~> 4.0.0'


gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'less-rails'
gem 'uglifier', '>= 1.0.3'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby


gem 'jquery-rails'
gem 'select2-rails'
gem 'bootstrap-datepicker-rails'

gem 'mysql2'
gem 'prawn'
gem 'haml-rails'
gem 'kaminari'
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git' # git for rails4
gem 'client_side_validations', git: 'git://github.com/bcardarella/client_side_validations.git', branch: '4-0-beta'
gem 'client_side_validations-simple_form', git: 'git://github.com/saveritemedical/client_side_validations-simple_form.git'
gem 'inherited_resources'
gem 'localize_input', git: "git://github.com/bennibu/localize_input.git"
gem 'wikicloth'
gem 'daemons'
gem 'twitter-bootstrap-rails'
gem 'simple-navigation'
gem 'simple-navigation-bootstrap'
#gem 'meta_search', git: 'git://github.com/jetthoughts/meta_search.git' # other git repo for rails4; still breaks form_for
gem 'acts_as_versioned', git: 'git://github.com/technoweenie/acts_as_versioned.git' # Use this instead of rubygem
gem 'acts_as_tree'
gem "rails-settings-cached", "0.3.1"
gem 'resque'
gem 'whenever', require: false # For defining cronjobs, see config/schedule.rb
gem 'protected_attributes'
gem 'memoist'

group :production do
  gem 'exception_notification'
end

group :development do
  gem 'sqlite3'
  gem 'mailcatcher'
  
  # Better error output
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem "rails-i18n-debug"
  
  # Re-enable rails benchmarker/profiler
  gem 'ruby-prof'
  gem 'test-unit'

  # Get infos when not using proper eager loading
  gem 'bullet'

  # Hide assets requests in log
  gem 'quiet_assets'
  
  # Deploy with Capistrano
  gem 'capistrano', '2.13.5'
  gem 'capistrano-ext'
  #gem 'common_deploy', require: false, path: '../../common_deploy' # pending foodcoops/foodsoft#34,  git: 'git://github.com/fsmanuel/common_deploy.git'
  # Avoid having content-length warnings
  gem 'thin'
end

# Gems left for backwards compatibility
gem 'acts_as_configurable', git: 'git://github.com/bwalding/acts_as_configurable.git' # user settings migration needs it

