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
    @time = Array.new(5) { [] }
    @action = Array.new(5) { [] }
    
    for num in 0..4 do
        File.foreach("public/data/time/#{num}.txt", mode = "rt"){|f|
            f.each_line{|line|
                @time[num].push(line.chomp)
            }
        }
        
        File.foreach("public/data/action/#{num}.txt", mode = "rt"){|f|
            f.each_line{|line|
                @action[num].push(line.chomp)
            }
        }
    end
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

get '/result/:how_index/:what_index/:id' do
    @result = Aim.find_by(id: params[:id])
    
    if @result
        @id_boolean = true
    else
        @id_boolean = false
    end
    erb :result
end

get '/archive' do
    if session[:user]
        @archives = User.find(session[:user]).aims
    end
    erb :archive
end

get '/detail/:id' do
    @aim = Aim.find(params[:id])
    @date = @aim.created_at.strftime('%Y年%m月%d日')
    erb :detail
end

post '/select' do
    how_index = params[:how].to_i
    what_index = params[:what].to_i
    
    word_how = @time[how_index][rand(@time[how_index].size)]
    word_what =@action[what_index][rand(@action[what_index].size)]
    
    p word_how
    p word_what
    
    if session[:user]
        @aim = Aim.create(
            how: word_how,
            what: word_what,
            user_id: session[:user]
        )
    else
        @aim = Aim.create(
            how: word_how,
            what: word_what
        )
    end
    
    
    
    redirect "/result/#{how_index}/#{what_index}/#{@aim.id}"
end

post '/result/:how_index/:what_index/:id/reset' do
    beforeAim = Aim.find(params[:id])
    beforeAim.destroy()
    
    how_index = params[:how_index].to_i
    what_index = params[:what_index].to_i
    
    word_how = @time[how_index][rand(@time[how_index].size)]
    word_what =@action[what_index][rand(@action[what_index].size)]
    
    if session[:user]
        @aim = Aim.create(
            how: word_how,
            what: word_what,
            user_id: session[:user]
        )
    else
        @aim = Aim.create(
            how: word_how,
            what: word_what
        )
    end
    
    redirect "/result/#{how_index}/#{what_index}/#{@aim.id}"
end