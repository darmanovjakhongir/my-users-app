require 'sqlite3'
require 'bcrypt'

class User
  attr_accessor :firstname, :lastname, :age, :password, :email
  attr_reader :id

  def initialize(firstname, lastname, age, password, email, id = nil)
    @firstname = firstname
    @lastname = lastname
    @age = age
    @password = password
    @id = id
    @email = email
  end

  def self.connection
    return @db if defined?(@db) && @db

    begin
      @db = SQLite3::Database.new 'db.sql'
      @db.results_as_hash = true
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          firstname STRING,
          lastname STRING,
          age INTEGER,
          password STRING,
          email STRING
        )
      SQL
      @db
    rescue SQLite3::Exception => err
      puts "Database error: #{err}"
      nil
    end
  end

  def self.create(user_info)
    @db = self.connection
    hashed_password = BCrypt::Password.create(user_info[:password])

    @db.execute "INSERT INTO users(firstname, lastname, age, password, email) VALUES (?, ?, ?, ?, ?)",
                user_info[:firstname], user_info[:lastname], user_info[:age], hashed_password, user_info[:email]

    new_user = User.new(user_info[:firstname], user_info[:lastname], user_info[:age], hashed_password, user_info[:email])
    new_user.instance_variable_set(:@id, @db.last_insert_row_id) 
    @db.close
    new_user
  end

  def self.authenticate(password, email)
    @db = self.connection
    user_attn = @db.execute "SELECT * FROM users WHERE email = ?", email
    @db.close

    if user_attn.any? && BCrypt::Password.new(user_attn[0]['password']) == password
      return user_attn
    else
      return []
    end
  end

  def self.find(user_id)
    @db = self.connection
    user = @db.execute "SELECT * FROM users WHERE id = ?", user_id
    @db.close

    return nil if user.empty? 

    User.new(user[0]["firstname"], user[0]["lastname"], user[0]["age"], user[0]["password"], user[0]["email"], user[0]["id"])
  end

  def self.all
    @db = self.connection
    all_users = @db.execute "SELECT * FROM users"
    @db.close
    all_users.map do |user_data|
      User.new(user_data["firstname"], user_data["lastname"], user_data["age"], user_data["password"], user_data["email"], user_data["id"])
    end
  end

  def self.destroy(user_id)
    @db = self.connection
    @db.execute "DELETE FROM users WHERE id = ?", user_id
    @db.close
  end

  def self.update(user_id, attribute, value)
    @db = self.connection
    if attribute == 'password'
      value = BCrypt::Password.create(value)  
    end
    @db.execute "UPDATE users SET #{attribute} = ? WHERE id = ?", value, user_id
    updated_user = self.find(user_id) 
    @db.close
    updated_user
  end
end
