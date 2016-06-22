require 'dm-validations'

class Customer
  include DataMapper::Resource

  property  :id,            Serial
  property  :name,          String
  property  :email,         String
  property  :api_key,       String,   default:  proc {|identity, id| SecureRandom.hex}
  property  :is_verified,   Boolean,  default:  false
  property  :session_id,    String,   required: false
  property  :api_calls,     Integer,  default:  0

  has n,    :apps,          model:    'CustomerApplication'
  has n,    :identities

  is :authenticatable, :validatable

  validates_presence_of   :email
  validates_length_of     :email, min: 6
  validates_uniqueness_of :email
  validates_presence_of   :name

  def send_verification_email
    token = SecureRandom.hex
    key = "verify_#{token}"
    $redis.set(key, id)
    $redis.expire(key, ONE_WEEK_IN_SECONDS)
    TidasBackend::App.deliver(:alerts, :verify_email, self, token)
  end

  def send_reset_password_email
    token = SecureRandom.hex
    key = "reset_password_#{token}"
    $redis.set(key, id)
    $redis.expire(key, ONE_DAY_IN_SECONDS)
    TidasBackend::App.deliver(:alerts, :reset_password, self, token)
  end

  def self.verify_with_id(verification_token)
    key = "verify_#{verification_token}"
    id = $redis.get(key)
    if customer = Customer.first(id:id)
      $redis.del(key)
      customer
    else
      nil
    end
  end

  def self.lookup_password_reset_with_token(password_token)
    key = "reset_password_#{password_token}"
    id  = $redis.get(key)
    if customer = Customer.first(id:id)
      customer
    else
      nil
    end
  end

  def self.delete_reset_password_token(password_token)
    key = "reset_password_#{password_token}"
    $redis.del(key)
  end

  def is_verified?
    is_verified
  end

end
