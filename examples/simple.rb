require 'kaffe'
require 'rack'


class MyApp < Kaffe::Base
  get '/?' do
    "Hello World"
  end
end

Rack::Handler::WEBrick.run MyApp
