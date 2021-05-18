source "https://rubygems.org"
ruby "2.4.1"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 5.1.6"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.0.0"
# Use Puma as the app server
gem "puma", "~> 4.3"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.7"
gem "jwt", "~> 1.5.6"
gem "simple_command"
gem "rest-client"

gem "apipie-rails", "~> 0.5.11"

gem "travis", "~> 1.8", ">= 1.8.8"

gem "codeclimate-test-reporter", group: :test, require: nil

gem "carrierwave", "~> 1.1"
gem "carrierwave-base64", "~> 2.5", ">= 2.5.3"

gem "simple_token_authentication", "~> 1.0"
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"
gem "octokit", "~> 4.0"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "minitest", "~> 5.8", ">= 5.8.4"
  gem "simplecov", require: false
  gem "minitest-reporters"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "rubocop"
end

group :production do
  gem "rails_12factor"
  gem "activesupport", "~> 5.1", ">= 5.1.4"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
