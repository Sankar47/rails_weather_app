# MyRailsApp

This is a Ruby on Rails 8.0.2 application running on Ruby 3.3.0.

## 🧰 Ruby and Rails Versions

- **Ruby**: 3.3.0
- **Rails**: 8.0.2

## 📦 System Dependencies

Before installing the app, make sure your system has:

- PostgreSQL
- Node.js and Yarn
- Redis (if using Solid Queue)

## 🛠 Installation

### 1. Clone the Repository

git clone https://github.com/Sankar47/rails_weather_app.git  
cd your-repo-name

### 2. Install Ruby (3.3.0)

Using `rbenv`:

rbenv install 3.3.0  
rbenv local 3.3.0

Using `rvm`:

rvm install 3.3.0  
rvm use 3.3.0 --default

### 3. Install Bundler and Gems

gem install bundler  
bundle install

### 4. Install Node and Yarn

**macOS (Homebrew):**

brew install node  
brew install yarn

**Ubuntu/Debian:**

sudo apt update  
sudo apt install nodejs yarnpkg

### 5. Set Up the Database

rails db:create  
rails db:migrate  
rails db:seed  # optional, if seeds.rb is present

### 6. Enable Caching (Recommended in Development)

Run the following command to toggle Action Controller caching:

rails dev:cache

This will enable or disable caching by creating or removing the `tmp/caching-dev.txt` file.


### 7. Optional: Install Redis (for background jobs)

**macOS (Homebrew):**

brew install redis  
brew services start redis

**Ubuntu/Debian:**

sudo apt install redis-server  
sudo systemctl enable redis  
sudo systemctl start redis

### 8. Start the Rails Server

bin/dev  # if using bin/dev with Foreman  
# OR  
rails server

Visit: http://localhost:3000

---

## ✅ Running Tests

Run the test suite using RSpec:

bundle exec rspec

Additional tools:

- brakeman  — for static security checks
- rubocop    — for code style linting

---

## 🔌 Tools & Services

- **Job Queues**: Solid Queue  
- **Caching**: Solid Cache  
- **WebSockets**: Solid Cable  
- **Asset Pipeline**: Propshaft  
- **HTTP Requests**: Faraday  
- **Form Helpers**: country_select

---

