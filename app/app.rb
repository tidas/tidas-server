require 'json'
require 'dm-validations'

module TidasBackend
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Warden

    disable :protect_from_csrf

    URL_FOR_DOCS = "https://github.com/tidas/tidas-docs"
    ##
    # Caching support.
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache.new(:LRUHash) # Keeps cached values in memory
    # set :cache, Padrino::Cache.new(:Memcached) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Memcached, '127.0.0.1:11211', :exception_retry_limit => 1)
    # set :cache, Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
    # set :cache, Padrino::Cache.new(:Redis) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Redis, :host => '127.0.0.1', :port => 6379, :db => 0)
    # set :cache, Padrino::Cache.new(:Redis, :backend => redis_instance)
    # set :cache, Padrino::Cache.new(:Mongo) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
    # set :cache, Padrino::Cache.new(:File, :dir => Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #
    configure :production do
      use Rack::SslEnforcer
      use Rack::Session::Cookie,  :key => '_rack_session',
                                  :path => '/',
                                  :expire_after => 2592000, # In seconds
                                  :secret => settings.session_secret
      set :delivery_method, smtp: {
        address:              'smtp.sendgrid.net',
        port:                 587,
        enable_starttls_auto: true,
        user_name:            ENV['SENDGRID_USERNAME'],
        password:             ENV['SENDGRID_PASSWORD'],
        authentication:       :plain,
        domain:               'passwordlessapps.com'
      }
    end

    get :ping do
      return Tidas::SuccessfulResult.new(message:%{Pong!}).to_json
    end

    get '/' do
      redirect_to url_for(:dashboard, :index)
    end

    not_found do
      slim :not_found, layout: :no_layout
    end

    error 500 do
      slim :error, layout: :no_layout
    end

    get "/500" do
      slim :error, layout: :no_layout
    end
    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 500 do
    #     render 'errors/500'
    #   end
    #
  end
end
