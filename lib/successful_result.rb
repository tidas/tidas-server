module Tidas
  class SuccessfulResult

    attr_reader :tidas_id, :message

    def initialize(attributes = {}) # :nodoc:
      @tidas_id = attributes[:tidas_id]
      @message  = attributes[:message]
      @returned_data = attributes[:returned_data]
    end

    def success?
      true
    end

    def to_json
      {
        successful_result: {
          tidas_id: @tidas_id,
          message:  @message,
          returned_data: @returned_data
        }
      }.to_json
    end

  end
end
