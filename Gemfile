 ruby '2.5.1'

source 'https://rubygems.org'
gem 'sinatra'
gem 'activerecord', '4.2.5'
gem 'sinatra-activerecord'
gem 'thin'
gem 'require_all'
gem 'bcrypt'
gem "password_strength"
gem 'rack-flash3'
gem 'sinatra-flash'

group :production do
  gem 'thin'
  gem 'pg'
end

group :development do
  gem 'shotgun'
  gem 'pry'
  gem 'tux'
  gem 'sqlite3'
end
