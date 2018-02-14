ruby '2.2.2'

source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'
gem 'resque'

# Component requirements
gem 'slim'
gem 'dm-is-authenticatable', '~> 0.2.0'
gem 'dm-postgres-adapter'
gem 'dm-validations'
gem 'dm-timestamps'
gem 'dm-migrations'
gem 'dm-constraints'
gem 'dm-aggregates'
gem 'dm-serializer'
gem 'dm-types'
gem 'dm-core'

gem 'rack-ssl-enforcer'

group :test do
  gem 'simplecov', :require => false
  gem 'rspec'
  gem 'mock_redis', '~> 0.14'
  gem 'resque_spec', '~> 0.16'
  gem 'rack-test', :require => 'rack/test'
  gem 'capybara', '~> 2.4'
  gem "codeclimate-test-reporter", require: nil
end

group :test, :development do

end

gem 'honeybadger'

# Padrino Stable Gem
gem 'padrino', '0.12.6'
gem 'padrino-warden', '~> 0.20'

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.12.6'
# end
