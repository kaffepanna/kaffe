# Kaffe Framework
This is a minimalistic webframework inspired by sinatra and 
rails.

## Basic usage
The idea is to use be able to create modular applications and
forward requests between them.

        class Blog < Kaffe::Base
          use Rack::CommonLogger

          get '/?' do
            "Hello From Blog"            
          end
        end

        class Admin < Kaffe::Base
          get '/login' do
            ... Login logics ...
          end

          error 400..500 do |code, message|
            .. show pretty error message ..
          end
        end

        class MyApp < Kaffe::Base
          route '/blog', Blog
          route '/admin', Admin
        end

        run MyApp

## API overview
