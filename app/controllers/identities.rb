TidasBackend::App.controllers :identities do
  
  before do
    api_key = params[:api_key]
    unless api_key
      halt Tidas::ErrorResult.new(errors:Tidas::Validator::ERRORS[:no_api_key]).to_json
    end

    unless (@customer = Customer.first(api_key: api_key))
      halt Tidas::ErrorResult.new(errors:Tidas::Validator::ERRORS[:bad_api_key]).to_json
    end

    request_type = request.env["REQUEST_METHOD"]

    @customer.update(api_calls:@customer.api_calls+1)

    if request_type == "POST"
      @body = request.body.read
      @parsed = JSON.parse(@body, symbolize_names: true)
    end

    @application = case request_type
    when "POST"
      CustomerApplication.first(customer:@customer, name:@parsed[:application])
    when "GET"
      CustomerApplication.first(customer:@customer, name:params[:application])
    end

    unless @application
      halt Tidas::ErrorResult.new(errors:Tidas::Validator::ERRORS[:unknown_application]).to_json
    end

  end

  get :index, map: 'identities/index' do
    if params[:tidas_id]
      identities = Identity.all(
        id: params[:tidas_id],
        customer:@customer,
        app:@application
      )
    else
      identities = Identity.all(
        customer:@customer,
        app:@application
      )
    end
    if params[:tidas_id]
      include_key = true
    else
      include_key = false
    end
    Identity.list_identities(identities, include_key).to_json
  end

  post :enroll do
    enrollment_data = Tidas::EnrollmentData.init_with_data_for_customer(@parsed, @customer)
    result = Identity.enroll_with_data(enrollment_data)
    result.to_json
  end

  post :validate do
    validator = Tidas::Validator.init_with_data_for_customer_and_application(@parsed, @customer, @application)
    result = validator.validate
    result.to_json
  end

  post :deactivate do
    result = Identity.deactivate_user_with_data(@parsed[:tidas_id], @customer, @parsed[:application])
    result.to_json
  end

  post :activate do
    result = Identity.activate_user_with_data(@parsed[:tidas_id], @customer, @parsed[:application])
    result.to_json
  end

end
