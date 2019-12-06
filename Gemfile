source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.4"

gem "bootsnap",     ">= 1.1.0", require: false
gem "dotenv-rails", "2.7.5"
gem "faraday",      "0.15.4"
gem "grape",        "1.2.4"
gem "pg",           ">= 0.18", "< 2.0"
gem "puma",         "3.12.2"
gem "rack-cors",    "1.0.3"
gem "rails",        "6.0.0"
gem "rubocop",      "0.74.0"
gem "sidekiq",      "6.0.0"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails",  "~> 0.3.9"
  gem "pry-remote", "~> 0.1.8"
end

group :test do
  gem "database_cleaner",  "1.5.3"
  gem "factory_bot_rails", "5.0.2"
  gem "rspec-rails",       "3.8.2"
  gem "simplecov",         "0.14.0"
  gem "webmock",           "3.7.1"
end

group :development do
  gem "listen",                ">= 3.0.5", "< 3.2"
  gem "spring",                "2.1.0"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
