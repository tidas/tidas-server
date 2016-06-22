TidasBackend::App.mailer :alerts do
  defaults from: 'hello@passwordlessapps.com'

  email :verify_email do |customer, token|
    to customer.email
    subject 'Verify your Tidas account'
    content_type :html

    locals customer: customer, token:token
    slim :'alerts/verify_email'
  end

  email :reset_password do |customer, token|
    to customer.email
    subject 'Reset Password Request for Tidas'
    content_type :html

    locals customer: customer, token:token
    slim :'alerts/reset_password'
  end

end
