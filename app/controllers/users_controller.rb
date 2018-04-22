class UsersController < ApplicationController

  get '/' do
    erb :'/index'
  end

  get '/signup' do
    if logged_in?
      redirect to '/tweets'
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    if params[:username] == ""|| params[:email] == ""|| params[:password] == ""
      redirect '/signup'
    else
      @user = User.create(params)
      @user.save
      session[:user_id] = @user.id
      redirect '/tweets'
    end
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
      @user = User.find_by(username: params["username"])
      if @user && @user.authenticate(params["password"])
        session[:user_id] = @user.id
        redirect '/tweets'
      else
        redirect '/login'
      end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if @user.slug == current_user
      erb :'/users/show'
    end
  end
end
