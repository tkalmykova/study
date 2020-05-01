module Inatra
  @handlers = {}

  class << self
    def routes(&block)
      instance_eval(&block)
    end

    def call(env)
      handle_request(env['REQUEST_METHOD'], env['PATH_INFO'])
    end

    private

    def method_missing(method_name, path, &block)
      @handlers[method_name] ||= {}
      @handlers[method_name][path] = block
    end

    def handle_request(method, path)
      handler = @handlers.dig(method.downcase.to_sym, path)
      return [404, {}, ['Not Found']] unless handler

      handler.call
    end
  end
end
