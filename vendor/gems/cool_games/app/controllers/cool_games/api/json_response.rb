module CoolGames
  module Api
    class JsonResponse

      SUCCESS          = :success
      VALIDATION_ERROR = :validation_error

      Error = Struct.new(:code, :message, :field)

      attr_accessor :body

      def initialize status = :success, body = nil, &block
        @status = status
        @body   = body
        @errors = []

        instance_eval &block if block_given?
      end

      def add_error code, message, field = nil
        @errors << Error.new(code, message, field)
      end

      def to_s *args
        result = {
          :status => @status
        }
        result[:body] = @body if @body
        result[:errors] = @errors unless @errors.empty?

        result.to_json
      end
      alias to_json to_s

      def self.success body = nil, &block
        new SUCCESS, body, &block
      end
    end
  end
end

