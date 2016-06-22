TidasBackend::App.controllers :dashboard do
  before {authorize!}

  layout :dashboard
  
  get :index, map: '/dashboard' do
    @customer = current_user
    if @customer.apps.empty?
      redirect_to url_for(:applications, :add_application)
    end
    slim :'dashboard/index'
  end
end
