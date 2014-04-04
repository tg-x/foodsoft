# Custom uglifier invocation to workaround https://github.com/mishoo/UglifyJS2/issues/434
# See also https://github.com/foodcoop-adam/foodsoft/issues/105
#
#
# To use this, make sure you have the following in config/application.rb:
#
#     require_relative 'initializers/uglifier.rb'
#     module MyApp
#       class Application < Rails::Application
#         config.assets.js_compressor = Foodsoft::UglifyTransformer.new
#       end
#     end
#
module Foodsoft
  class UglifyTransformer
    def compress(string)
      require 'uglifier'
      ::Uglifier.compile(string, output: {quote_keys: true})
    end
  end
end
