if RACK_ENV == 'production'
  require 'honeybadger'

  env = if ENV['IS_STAGING'] == 'true'
          'staging'
        else                                
          RACK_ENV
        end

  HONEYBADGER_CONFIG = Honeybadger::Config.new(env: env)
  Honeybadger.start(HONEYBADGER_CONFIG)
end
