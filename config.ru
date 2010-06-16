load 'lib/kaffe.rb'

class Controller < Kaffe::Base
  get '/test' do
    "Controller Test"
  end
  get '/test/:id?' do |id|
    "Hello Controller #{id}"
  end
end

class TestApp < Kaffe::Base
  route '/controller', Controller
  error 400..500 do
    "Got 404 in TestApp"
  end
end
use Rack::Reloader
run TestApp.new
