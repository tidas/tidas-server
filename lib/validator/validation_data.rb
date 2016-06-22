require 'openssl'

module Tidas
  class Validator
    class ValidationData

      attr_reader :public_key

      def self.init_with_data_and_public_key(data, public_key)
        self.new(data: data, public_key: public_key)
      end

      def valid?
        return false unless @public_key
        key_for_verify = OpenSSL::PKey::EC.new(@public_key)
        key_for_verify.dsa_verify_asn1(@data_hash, @signature)
      end

      private

      def initialize(attributes)
        validation_data = attributes[:data]
        @public_key     = attributes[:public_key]
        @data_hash  = validation_data[:data_hash]
        @signature  = validation_data[:signature]
      end
    end
  end
end
