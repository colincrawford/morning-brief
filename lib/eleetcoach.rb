require "net/http"
require "json"

module Eleetcoach
  class WikipediaAlgorithm
    attr_reader :categories, :link

    def initialize(categories:, link:)
      @categories = categories
      @link = link
    end
  end

  class LeetcodeProblem
    attr_reader :link, :difficulty, :title

    def initialize(link:, difficulty:, title:)
      @link = link
      @difficulty = difficulty
      @title = title
    end
  end

  class Client
    def initialize(logger:, base_url:, minimum_leetcode_difficulty:)
      @logger = logger
      @base_url = base_url
      @minimum_leetcode_difficulty = minimum_leetcode_difficulty
    end

    def api_url
      "#{@base_url}/api"
    end

    def wikipedia_algorithm
      @logger.info("[Eleetcoach::Client] - Getting wikipedia algorithm")
      uri = URI("#{api_url}/wikipedia-algorithm")
      resp = Net::HTTP.get(uri)
      json = JSON.parse(resp)
      @logger.info("[Eleetcoach::Client] - Got wikipedia algorithm")
      WikipediaAlgorithm.new(
        link: json['link'],
        categories: json['categories']
      )
    end

    def leetcode_problem
      @logger.info("[Eleetcoach::Client] - Getting leetcode problem")
      uri = URI("#{api_url}/leetcode-problem?minimum-difficulty=#{@minimum_leetcode_difficulty}")
      resp = Net::HTTP.get(uri)
      json = JSON.parse(resp)
      @logger.info("[Eleetcoach::Client] - Got leetcode problem")
      LeetcodeProblem.new(
        link: json['link'],
        difficulty: json['difficulty'],
        title: json['title']
      )
    end
  end
end
