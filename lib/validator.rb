module Tidas
  class Validator

    ERRORS = {
      bad_data: ["Data is not valid"],
      unknown_identity: ["Unknown identity for your application"],
      deactivated_user: ["This user has been deactivated - reactivate them to validate data"],
      id_required: ["Must provide an ID to overwrite a public key"],
      no_api_key: ["No API key provided"],
      bad_api_key: ["Bad API key provided"],
      unknown_application: ["Unknown application for your account"],
      no_tidas_id: ["No tidas_id supplied. This field is required for validation"],
      old_data: ["Data is not fresh (originated over 60s ago)"]
    }
    
    def validate
      unless user_provided?
        return Tidas::ErrorResult.new(errors:ERRORS[:no_tidas_id])
      end
      unless validate_identity
        return Tidas::ErrorResult.new(errors:ERRORS[:unknown_identity])
      end
      unless validate_timeliness
        return Tidas::ErrorResult.new(errors:ERRORS[:old_data])
      end
      unless @validation_data.valid?
        return Tidas::ErrorResult.new(errors:ERRORS[:bad_data])
      end
      unless validate_active
        return Tidas::ErrorResult.new(tidas_id:@provided_identity.id, errors:ERRORS[:deactivated_user])
      end
      @provided_identity.update(last_seen: DateTime.now)
      return Tidas::SuccessfulResult.new(tidas_id:@provided_identity.id, message:%{Data passes validation})
    end

    def self.init_with_data_for_customer_and_application(data, customer, application)
      self.new(data:data, customer:customer, application:application)
    end

    private

    def initialize(attributes)
      data = attributes[:data]
      @customer = attributes[:customer]
      @application = attributes[:application]
      @tidas_id = data[:tidas_id]

      @unpacked_data = Tidas::Utilities::Unpacker.init_with_blob(data[:validation_data]).parse

      @provided_identity = Identity.first(id:@tidas_id, customer:@customer, app:@application)
      if @provided_identity
        @public_key = @provided_identity.pub_key
      end
      @validation_data = ValidationData.init_with_data_and_public_key(@unpacked_data, @public_key)
    end

    def user_provided?
      @tidas_id != nil
    end

    def validate_identity
      @provided_identity != nil
    end

    def validate_active
      @provided_identity.deactivated == false
    end

    def validate_timeliness
      @unpacked_data[:timestamp] > Time.now - 60
    end

  end
end
