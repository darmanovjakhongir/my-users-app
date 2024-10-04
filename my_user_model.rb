require 'sqlite3'

class User
def create(user_info)
db = SQLite3::Database.open 'db.sql'
new_user_data = user_info.split(',').map( &: strip)
sql = 'INSERT INTO users(firstname, lastname, age, password, email) VALUES (?, ?, ?, ?, ?);'
db.execute(sql, new_user_data)
result = db.execute 'SELECT last_insert_rowid();'
result.flatten.first
ensure
db.close
end

def find(user_id)
db = SQLite3::Database.open 'db.sql'
id = user_id.to_i
sql = 'SELECT * FROM users WHERE user_id = ?'
result = db.execute(sql, id)
user_hash = result.map do | row | {
    user_id: row[0],
    firstname: row[1],
    lastname: row[2],
    age: row[3],
    email: row[5]
  }
  end
user_hash
ensure
db.close
end

def all
db = SQLite3::Database.open 'db.sql'
begin
result = db.execute('SELECT * FROM users')
users_hash = result.map do | row | {
    user_id: row[0],
    firstname: row[1],
    lastname: row[2],
    age: row[3],
    password: row[4],
    email: row[5]
  }
  end
users_hash
ensure
db.close
end
end

def update(user_id, attribute, value)
db = SQLite3::Database.open 'db.sql'
id = user_id.to_i
att = attribute
val = value
sql = "UPDATE users SET #{att} = ? WHERE user_id = ?"
db.execute(sql, val, id)
result = db.execute "SELECT * FROM users WHERE user_id = #{id}"
user_hash = result.map do | row | {
    user_id: row[0],
    firstname: row[1],
    lastname: row[2],
    age: row[3],
    email: row[5]
  }
  end
user_hash
ensure
db.close
end

def destroy(user_id)
db = SQLite3::Database.open 'db.sql'
id = user_id.to_i
sql = 'DELETE FROM users WHERE user_id = ?'
db.execute(sql, id)
ensure
db.close
end
end
