require 'sinatra'
require 'json'
require 'bcrypt'
require_relative 'my_user_model.rb'

enable :sessions
set :port, 8080
set :bind, '0.0.0.0'

get '/' do
  @users = User.all()
  erb :index
end

get '/users' do
  content_type :json
  status 200
  User.all.map { |user| user.slice("firstname", "lastname", "age", "email") }.to_json
end

post '/users' do
  content_type :json

  if params[:firstname] && params[:password] && params[:email]
    create_user = User.create(params)

    if create_user.persisted?
      new_user = User.find(create_user.id)
      user = {
        firstname: new_user.firstname,
        lastname: new_user.lastname,
        age: new_user.age,
        email: new_user.email
      }
      status 201
      user.to_json
    else
      status 422 
      { error: "User creation failed" }.to_json
    end

  else

    list_user = User.authenticate(params[:password], params[:email])
    if list_user && !list_user.empty?
      session[:user_id] = list_user[0]["id"]
      status 200
      list_user[0].to_json
    else
      status 401
      { error: "Authentication failed" }.to_json
    end
  end
end

post '/sign_in' do
  content_type :json
  user = User.authenticate(params[:password], params[:email])

  if user && !user.empty?
    session[:user_id] = user[0]["id"]
    status 200
    user[0].to_json
  else
    status 401
    { error: "Invalid credentials" }.to_json
  end
end

put '/users' do
  content_type :json
  if session[:user_id]
    User.update(session[:user_id], 'password', params[:password])
    my_user = User.find(session[:user_id])

    status 200
    {
      firstname: my_user.firstname,
      lastname: my_user.lastname,
      age: my_user.age,
      email: my_user.email
    }.to_json
  else
    status 401
    { error: "Unauthorized" }.to_json
  end
end

delete '/sign_out' do
  session[:user_id] = nil
  status 204
end

delete '/users' do
  if session[:user_id]
    User.destroy(session[:user_id])
    session[:user_id] = nil
    status 204
  else
    status 401
    { error: "Unauthorized" }.to_json
  end
end
