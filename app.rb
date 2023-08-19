require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'
enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

before do

end

get '/' do
    erb :index
end

get '/select' do
    erb :select
end

get '/account' do
    erb :account
end

get '/signup' do
    erb :signup
end

get '/login' do
    erb :login
end

post '/signup' do
    user = User.create(
        name: params[:name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
    )
    
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/account' 
end

post '/login' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
       session[:user] = user.id
    end
    redirect '/account'
end

get '/signout' do
    session[:user] = nil
    redirect '/account'
end