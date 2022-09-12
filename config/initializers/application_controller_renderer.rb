# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end

require 'alphavantage'

Alphavantage.configure do |config|
  config.api_key = 'XNUWMJDOGH79P0AI'
end
