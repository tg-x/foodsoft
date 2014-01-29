require 'adyen'
require 'foodsoft_adyen/engine'
require 'foodsoft_adyen/configuration'
require 'foodsoft_adyen/railtie'

module FoodsoftAdyen
  def self.configuration
    @configuration ||= FoodsoftAdyen::Configuration.new
  end

  # return whether the current request is likely to support the mobile PIN app
  def self.detect_pin(request)
    true if self.get_mobile(request)
  end

  protected

  # return mobile platform of current request, if any
  def self.get_mobile(request)
    if request.user_agent.match /\bAndroid\b/
      'Android'
    elsif request.user_agent.match /\b(iPod|iPhone|iPad)\b/
      'iOS'
    else
      nil
    end
  end
end
