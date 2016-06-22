require 'warden'

Warden::Strategies.add(:password) do
  def valid?
    params["email"] || params["password"]
  end

  def authenticate!
    u = Customer.authenticate(
          :email    => params["email"].downcase,
          :password => params["password"]
        )

    if u.nil?
      @errors = ["Invalid username or password"]

    else
      success!(u)
    end
  end
  
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  Customer.get(id)
end

Warden::Manager.after_authentication do |user, auth, opts|
  new_session_id = SecureRandom.hex
  auth.raw_session["auth_id"] = new_session_id
  referrer = auth.raw_session["referrer"]

  user.update(session_id: new_session_id)

  if referrer
    response = Rack::Response.new
    response.redirect referrer
    throw :warden, response.finish
  end
end

Warden::Manager.after_fetch do |user, auth, opts|
  session_id = auth.raw_session["auth_id"]
  unless Customer.first(session_id: session_id)
    auth.logout
  end
end

Warden::Manager.before_logout do |user, auth, opts|
  session_id = auth.raw_session["auth_id"]
  if u = Customer.first(session_id:session_id)
    u.update(session_id:nil)
  end
end
