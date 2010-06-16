load 'lib/kaffe.rb'

class Controller < Kaffe::Base
  get '/test' do
    "Hello Controller"
  end
end

class TestApp < Kaffe::Base
  route '/controller', Controller
  error 400..501 do |code, message|
    "Got Error #{code}, '#{message}'"
  end
end
use Rack::Reloader
run TestApp.new
