# My Users App

My Users App is a simple web application built using **Sinatra** and **SQLite3** for managing user information. The application allows users to sign up, log in, update their information, and delete their accounts. Passwords are securely hashed using **BCrypt**.

## Contents

- [Task](#task)
- [Description](#description)
- [Installation](#installation)
- [Usage](#usage)

## Task

- [x] You will need to create a folder and in this folder will be additional files containing your work.
- [x] Folder names must start with special file names and also contain ( my_user_model.rb app.rb views/index.html ).
- [x] Ensure user authentication, password hashing, and CRUD operations on user data.
- [x] Provide endpoints for creating, updating, deleting, and authenticating users.

## Description

This project is a simple web-based User App built using **Sinatra** and **SQLite3**. It allows users to:

- **Register**: Create new users.
- **Sign in**: Authenticate existing users.
- **Update profiles**: Update the user's password or other details.
- **Log out**: End the session for the authenticated user.

The app also provides a basic HTML view listing all users, alongside several API endpoints to manage and interact with users.

## Installation

1. Make sure you have Ruby installed on your system.
2. Clone this repository: `https://github.com/darmanovjakhongir/my-users-app.git`.
3. Go to the project directory: `cd my-users-app`.
4. Install the required gems: `bundle install`.
5. Make sure SQLite3 is installed. If not, install it through your package manager.

## Usage

1. Start the Sinatra app by running the following command: `ruby app.rb`.
2. Open a browser and go to `http://localhost:8080/` to see a list of all users.
3. After signing in, your session will be stored in a cookie. You can test subsequent requests using curl with the --cookie option.
4. The app uses a local SQLite3 database (db.sql) to store user data. It will be automatically created when the app runs for the first time.

## The Core Team

<span><i> Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px' /></span >
