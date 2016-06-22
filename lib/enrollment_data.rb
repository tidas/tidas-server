module Tidas
  class EnrollmentData

    attr_reader :id, :pub_key, :customer, :application, :overwrite, :errors

    def self.init_with_data_for_customer(data, customer)
      Tidas::EnrollmentData.new({data: data, customer: customer})
    end

    private

    def initialize(attributes)
      data              = attributes[:data]

      @customer         = attributes[:customer]

      @id               = data[:tidas_id]
      @overwrite        = data[:overwrite]
      @application      = data[:application]

      enrollment_data   = Tidas::Utilities::Unpacker.init_with_blob(data[:enrollment_data]).parse

      key_data          = enrollment_data[:public_key_data]
      key_builder       = Tidas::Utilities::KeyBuilder.init_with_bytes(key_data)
      @pub_key          = key_builder.export_pub
    end

  end
end
