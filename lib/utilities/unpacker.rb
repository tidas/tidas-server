require 'base64'

module Tidas
  module Utilities
    class Unpacker

      attr_accessor :parsed_data

      def self.init_with_blob(blob)
        Tidas::Utilities::Unpacker.new( {blob: blob} )
      end

      def parse
        pull_val_from_data(data_str)
        @parsed_data
      end

      def data_str
        Base64.decode64(@blob)
      end

      private

      def initialize(attributes)
        @blob = attributes[:blob]
        @parsed_data = {}
      end

      def pull_val_from_data(data)
        return unless data[5]
        type_char = data[0].unpack('C')[0]
        type_str  = Tidas::Utilities::SERIALIZATION_FIELDS[type_char]
        field_len = data[1..4].unpack('I')[0]

        val_end = 5+field_len-1
        raw_val = data[5..val_end] 

        val = extract_val(type_str, raw_val)

        @parsed_data[type_str] = val

        shorter_data = data[val_end+1..-1]
        if shorter_data && shorter_data.length > 0
          pull_val_from_data(shorter_data)
        end
      end

      def extract_val(type, raw_val)
        if type == :platform
          raw_val.unpack('C')[0]
        elsif type == :timestamp
          time_data = raw_val.unpack('I')[0]
          Time.at(time_data)
        else
          raw_val.unpack('C*').map{|e| e.chr }.join
        end
      end

    end
  end
end
