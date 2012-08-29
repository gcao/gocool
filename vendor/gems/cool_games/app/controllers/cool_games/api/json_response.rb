module CoolGames
  module Api
    class JsonResponse

      # TODO: return 404 for not_found and 401 for not_authenticated ?

      SUCCESS           = :success
      FAILURE           = :failure
      NOT_FOUND         = :not_found
      VALIDATION_ERROR  = :validation_error
      NOT_AUTHENTICATED = :not_authenticated
      LOGIN_FAILURE     = :login_failure

      Error = Struct.new(:code, :message, :field)
      Pagination = Struct.new(:page, :page_size, :total_pages, :total_entries)

      def initialize status = :success, body = nil, &block
        @status   = status
        self.body = body
        @errors   = []

        instance_eval &block if block_given?
      end

      def body= body
        if body.respond_to? :current_page
          @pagination = Pagination.new(body.current_page, body.per_page, body.total_pages, body.total_entries)
        end

        @body = body
      end

      def add_error code, message, field = nil
        @errors << Error.new(code, message, field)
      end

      def as_json *args
        result = {}
        result[:status]     = @status
        result[:body]       = @body       if @body
        result[:pagination] = @pagination if @pagination
        result[:errors]     = @errors     unless @errors.empty?
        result
      end

      def self.success body = nil, &block
        new SUCCESS, body, &block
      end

      def self.failure body = nil, &block
        new FAILURE, body, &block
      end

      def self.not_found body = nil, &block
        new NOT_FOUND, body, &block
      end

      def self.not_authenticated
        new NOT_AUTHENTICATED do
          error_code = 'api.errors.not_authenticated'
          add_error error_code, I18n.t(error_code), :auth_token
        end
      end
    end
  end
end

