module CoolGames
  module Api
    class JsonResponse

      SUCCESS          = :success
      VALIDATION_ERROR = :validation_error

      Error = Struct.new(:code, :message, :field)
      Pagination = Struct.new(:page, :page_size, :total_entries)

      def initialize status = :success, body = nil, &block
        @status   = status
        self.body = body
        @errors   = []

        instance_eval &block if block_given?
      end

      def body= body
        if body.respond_to? :current_page
          @pagination = Pagination.new(body.current_page, body.per_page, body.total_entries)
        end

        @body = body
      end

      def add_error code, message, field = nil
        @errors << Error.new(code, message, field)
      end

      def to_s *args
        result = {}
        result[:status]     = @status
        result[:body]       = @body       if @body
        result[:pagination] = @pagination if @pagination
        result[:errors]     = @errors     unless @errors.empty?

        result.to_json
      end
      alias to_json to_s

      def self.success body = nil, &block
        new SUCCESS, body, &block
      end
    end
  end
end

