require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative 'initializers/uglifier.rb'

# need to include this before requiring some other gems
#   http://stackoverflow.com/questions/20361428
I18n.enforce_available_locales = true

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Foodsoft
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # Internationalization.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.yml')]
    config.i18n.available_locales = Pathname.glob(Rails.root.join('config', 'locales', '??{-*,}.yml')).map{|p| p.basename('.yml').to_s }
    config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = false # TODO: Bette re-activate this!
    
    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.js_compressor = Foodsoft::UglifyTransformer.new

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # It would be nice not to enable database connection when precompiling assets,
    # but i18n-js requires initialization, that's why it's on.
    config.assets.initialize_on_precompile = true
  end
end
