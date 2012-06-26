module CoolGames
  module Api
    class JsonResponse

      Error = Struct.new(:code, :message, :field)

      attr_accessor :body

      def initialize status = 200, &block
        @status = status
        @errors = []
        instance_eval &block if block_given?
      end

      def add_error code, message, field = nil
        @errors << Error.new(code, message, field)
      end

      def to_s
        result = {
          :status => @status
        }
        result[:body] = @body if @body
        result[:errors] = @errors unless @errors.empty?

        result.to_json
      end
    end
  end
end

