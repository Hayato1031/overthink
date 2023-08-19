require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

before do

end

get '/' do
    erb :index
end