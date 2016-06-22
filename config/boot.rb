# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)
IS_STAGING = ENV['IS_STAGING'] == 'true'

MIDDLEWARE_URL = "https://github.com/trailofbits/tidas-ruby"
IOS_SDK_URL = "#"
IOS_URL = "https://github.com/trailofbits/tidas"

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# Workaround to https://github.com/padrino/padrino-framework/issues/1861
$LOAD_PATH.unshift(File.join(PADRINO_ROOT,'lib'))

case RACK_ENV
when 'production'
  ROOT_URL = "https://app.passwordlessapps.com"
  $redis = Redis.new(url: ENV["REDIS_URL"])
else
  ROOT_URL = "http://localhost:3000"
  if RACK_ENV == 'test'
    $redis = MockRedis.new
  else
    redis_conf = YAML.load_file(File.join(PADRINO_ROOT,'config','redis.yml'))
    $redis = Redis.new(url: redis_conf[RACK_ENV])
  end

end

Padrino.require_dependencies "#{Padrino.root}/config/*.rb"

ONE_DAY_IN_SECONDS = 86400
ONE_WEEK_IN_SECONDS = 604800

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
  DataMapper.finalize
end

Padrino.load!
