require "net/http"
require "json"
require "logger"

module Todoapp
  class Todo
    attr_reader :done, :description

    def initialize(done:, description:)
      @done = done
      @description = description
    end

    def to_s
      to_json
    end

    def to_json
      JSON::dump({
        done: @done,
        description: @description
      })
    end
  end

  class Client
    def initialize(logger:, todoapp_url:)
      @todoapp_url = todoapp_url
      @logger = logger
    end

    def todos
      @logger.info("[Todoapp::Client] - Getting todos")
      uri = URI("#{@todoapp_url}/api/todos")
      resp = Net::HTTP.get(uri)
      json_array = JSON.parse(resp)
      @logger.info("[Todoapp::Client] - Got todos")
      json_array.map do |json|
        Todo.new(
          done: json['done'],
          description: json['description']
        )
      end
    end
  end
end
