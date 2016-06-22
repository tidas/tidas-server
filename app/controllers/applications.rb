TidasBackend::App.controllers :applications do

  before {authorize!}

  layout :dashboard  

  get :add_application do
    @application = CustomerApplication.new
    slim :'applications/add_application'
  end

  post :add_application do
    @application = CustomerApplication.new(
      customer:current_user, name:params[:customer_application][:name]
    )
    if @application.save
      redirect_to url_for(:applications, :show, app_id: @application.id)
    else
      slim :'applications/add_application'
    end
  end

  get :show, map: "/applications", with: :app_id do
    @application = CustomerApplication.first(id:params[:app_id], customer:current_user)
    redirect_to url_for(:dashboard, :index) unless @application
    slim :'applications/show'
  end

  get :identity, map: "/applications/:app_id/identity/:identity_id" do

  end

end