c = Customer.first_or_create(name:'Trail of Bits', email:"nick.esposito@trailofbits.com", encrypted_password:'dev')
a = CustomerApplication.create(name:'Javelin', customer: c)

puts c.api_key
