load 'lib/kaffe.rb'

class TestApp < Kaffe::Base
  get '/test/:var?' do |var|
    @variable = var
    render('test.haml')
  end
end
use Rack::Reloader
run TestApp.new
