module Tidas
  class ErrorResult

    attr_reader :tidas_id, :message, :errors

    def initialize(attributes = {}) # :nodoc:
      @tidas_id = attributes[:tidas_id]
      @errors   = attributes[:errors]
    end

    def success?
      false
    end

    def errors
      @errors
    end

    def to_json
      {
        error_result: {
          tidas_id: @tidas_id,
          errors: @errors.map(&:to_s)
        }
      }.to_json
    end

  end
end
