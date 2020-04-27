module Inatra
  @@handlers = {}

  class << self
    def routes(&block)
      instance_eval(&block)
    end

    def call(env)
      handle_request(env['REQUEST_METHOD'], env['PATH_INFO'])
    end

    private

    def get(path, &block)
      add_handler('get', path, &block)
    end

    def post(path, &block)
      add_handler('post', path, &block)
    end

    def add_handler(verb, path)
      @@handlers[verb] ||= {}
      @@handlers[verb][path] = -> { yield }
    end

    def handle_request(method, path)
      handler = @@handlers.dig(method.downcase, path)
      handler.call if handler
    end
  end
end
