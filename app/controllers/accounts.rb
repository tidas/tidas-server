TidasBackend::App.controllers :accounts do

  layout :no_layout

  before :account do
    authorize!
  end

  get :register do
    @customer = Customer.new
    slim :'accounts/register'
  end

  post :register do
    @customer = Customer.new(
      name:                  params[:customer][:name],
      email:                 params[:customer][:email],
      password:              params[:customer][:password],
      password_confirmation: params[:customer][:password_confirmation]
    )

    if @customer.valid?
      @customer.save
      env['warden'].set_user(@customer)
      @customer.send_verification_email
      slim :'accounts/verify_email'
    else
      @errors = @customer.errors
      slim :'accounts/register'
    end
  end

  get :verify do
    redirect_to url_for(:dashboard, :index) if current_user && current_user.is_verified?
    @customer = current_user || Customer.new
    slim :'accounts/verify_email'
  end

  post :resend_email do
    @email = params[:customer][:email]
    if @customer = Customer.first(email:@email)
      if @customer.is_verified?
        redirect_to url_for(:dashboard, :index)
      else
        @customer.send_verification_email
      end
    else
      @customer = Customer.new
    end
    slim :'accounts/verify_email'
  end

  get :verify, with: [:verification_token] do
    if @customer = Customer.verify_with_id(params[:verification_token])
      @customer.update(is_verified:true)
      env['warden'].set_user(@customer)
      redirect_to url_for(:dashboard, :index)
    else
      env['warden'].logout
      redirect_to url_for(:sessions, :login)
    end
  end

  get :forgot_password do
    env['warden'].logout
    @customer = Customer.new
    slim :'accounts/forgot_password'
  end

  post :forgot_password do
    env['warden'].logout
    @email = params[:customer][:email]
    if @customer = Customer.first(email:@email)
      @customer.send_reset_password_email
    end
    redirect_to url_for(:sessions, :login)
  end

  get :reset_password, with: [:password_token] do
    if @customer = Customer.lookup_password_reset_with_token(params[:password_token])
      env['warden'].set_user(@customer)
      @customer_2 = Customer.new
      slim :'accounts/reset_password'
    else
      env['warden'].logout
      redirect_to url_for(:sessions, :login)
    end
  end

  post :reset_password, with: [:password_token] do
    if @customer = Customer.lookup_password_reset_with_token(params[:password_token])
      if @customer.update( password: params[:customer][:password], password_confirmation: params[:customer][:password_confirmation] )
        Customer.delete_reset_password_token(params[:password_token])
        redirect_to url_for(:dashboard, :index)
      else
        slim :'accounts/reset_password'
      end
    else
      env['warden'].set_user(nil)
      redirect_to url_for(:sessions, :login)
    end
  end

  get :account do
    slim :'accounts/account', layout: :dashboard
  end

end
