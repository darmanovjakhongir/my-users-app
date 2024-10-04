require 'sinatra'

require_relative 'my_user_model'

enable: sessions

set: views, File.dirname(__FILE__) + '/views'
set: port, 8080
set: bind, '0.0.0.0'

DB_PATH = 'db.sql'

def with_user
user = User.new
yield(user)
end

get '/'
do
  user = User.new
@users = user.all
erb: index
end

get '/users'
do
  with_user do | user |
    users = user.all
  users.to_json
end
end

post '/users'
do
  user_info = "#{params[:firstname]}, #{params[:lastname]}, #{params[:age]}, #{params[:password]}, #{params[:email]}"
with_user do | user |
  user_id = user.create(user_info)
created_user = user.find(user_id)
created_user.delete(: password)
created_user.to_json
end
end

post '/sign_in'
do
  email = params[: email]
password = params[: password]
with_user do | user |
  user_record = user.all.find {
    | u | u[: email] == email && u[: password] == password
  }
if user_record
session[: user_id] = user_record[: user_id]
user_record.delete(: password).to_s
user_record.to_json
else
  status 401 'Invalid credentials'
end
end
end

put '/users'
do
  user_id = session[: user_id]
new_password = params[: password]
if user_id
with_user do | user |
  user_record = user.update(user_id, 'password', new_password)
user_record.delete(: password).to_s
user_record.to_json
end
else
  status 401 'Unauthorized: You need to be logged in to perform this action.'
end
end

delete '/sign_out'
do
  session.delete(: user_id)
status 204
end

delete '/users'
do
  user_id = session[: user_id]
if user_id
with_user do | user |
  user.destroy(user_id)
end
session.delete(: user_id)
status 204
else
  status 401 'Unauthorized: You need to be logged in to perform this action.'
end
end
