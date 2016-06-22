class Identity
  include DataMapper::Resource

  property :id,           String,   key:      true,
                                    length:   255,
                                    default:  proc {|identity, id| SecureRandom.hex}
  property :pub_key,      Text
  property :deactivated,  Boolean,  default: false
  property :last_seen,    Time,     required: false


  timestamps :created_at

  belongs_to :customer
  belongs_to :app,        model:    'CustomerApplication'

  validates_with_method :pub_key, :check_public_key
  validates_with_method :pub_key, :unique_id_by_customer_and_application

  validates_presence_of :customer, :message => "Customer not found"
  validates_presence_of :app_id, :message => "Application not found"

  def self.enroll_with_data(enrollment_data)
    application = CustomerApplication.first(
      customer: enrollment_data.customer,
      name: enrollment_data.application
    )

    if enrollment_data.overwrite
      overwrite_pub_key_for_user(enrollment_data, application)
    else
      enroll_new_user(enrollment_data, application)
    end

  end

  def self.enroll_new_user(data, application)
    i = Identity.new(
      customer:data.customer,
      app:application,
      pub_key: data.pub_key
    )
    supplied_id = data.id
    if supplied_id != nil
      i.id = supplied_id
    end
    validate_save(i)
  end

  def self.overwrite_pub_key_for_user(data, application)
    unless data.id
      return Tidas::ErrorResult.new(errors:Tidas::Validator::ERRORS[:id_required])
    end
    i = Identity.first(id:data.id, customer:data.customer, app:application)
    if i == nil
      return Tidas::ErrorResult.new(errors:Tidas::Validator::ERRORS[:unknown_identity])
    end
    i.pub_key = data.pub_key

    validate_save(i)
  end

  def self.validate_save(identity)
    if identity.save
      Tidas::SuccessfulResult.new(tidas_id:identity.id, message:%{Identity successfully saved})
    else
      Tidas::ErrorResult.new(errors:identity.errors.map(&:first))
    end
  end

  def check_public_key
    begin
      OpenSSL::PKey::EC.new(pub_key).check_key
    rescue
      return [false, "Bad Key Data"]
    end
    true
  end

  def unique_id_by_customer_and_application
    return true unless new?
    if customer.identities.first(pub_key:pub_key, app:app, id:id) != nil
      return [false, "This id is associated with another user"]
    end
    true
  end

  def self.deactivate_user_with_data(id, customer, application)
    change_user_activation_with_data(id, customer, application, true, "deactivated")
  end

  def self.activate_user_with_data(id, customer, application)
    change_user_activation_with_data(id, customer, application, false, "activated")
  end

  def self.change_user_activation_with_data(id, customer, application, deactivated, message)
    i = Identity.first(
      customer: customer,
      app: CustomerApplication.first(
        customer: customer,
        name: application
      ),
      id:id
    )
    if i == nil
      return Tidas::ErrorResult.new(errors:Tidas::Validator::ERRORS[:unknown_identity])
    elsif i.update(deactivated: deactivated)
      return Tidas::SuccessfulResult.new(tidas_id:i.id, message:%{Identity successfully #{message}})
    else
      Tidas::ErrorResult.new(errors:i.errors.map(&:first))
    end
  end

  def self.list_identities(identities, include_key = false)
    begin
      if include_key
        identity_data = {identities: identities.map(&:to_hash_with_key)}.to_json
      else
        identity_data = {identities: identities.map(&:to_hash)}.to_json
      end
      return Tidas::SuccessfulResult.new(returned_data:identity_data)
    rescue
      return Tidas::ErrorResult.new(errors:Tidas::Validator::ERRORS[:bad_data])
    end
  end

  def to_hash_with_key
    hash = to_hash
    hash[:public_key] = pub_key
    hash
  end

  def to_hash
    {
      id: id,
      deactivated: deactivated,
      app: app.to_s
    }
  end

end
