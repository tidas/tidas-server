c = Customer.first_or_create(name:'Trail of Bits', email:"nick.esposito@trailofbits.com", password:'dev', password_confirmation:'dev')
a = CustomerApplication.create(name:'Javelin', customer: c)

puts c.api_key
