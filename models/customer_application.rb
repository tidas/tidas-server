class CustomerApplication
  include DataMapper::Resource

  property    :id, Serial
  property    :name, String

  belongs_to  :customer

  validates_with_method :name, method: :check_name


  def identities
    Identity.all(app:self, customer:customer)
  end

  def active_identities
    identities.all(deactivated: false)
  end

  def deactivated_identities
    identities.all(deactivated: true)
  end

  def to_s
    name
  end

  def check_name
    return true unless new?
    if CustomerApplication.first(name:name, customer:customer)
      return [false, "You already have an application with this name"];
    end
    true
  end
end
