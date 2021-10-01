require "json"

class Config
  def initialize(logger:, config_file:)
    @logger = logger
    config_f = config_file || "config.json"

    if File.file?(config_f)
      read_config_file(config_f)
    else
      @logger.error { "No config file found" }
      raise "No Config File"
    end
  end

  def minimum_leetcode_difficulty
    @config[:minimum_leetcode_difficulty]
  end

  def send_list
    @config[:send_list]
  end

  def gmail_email
    @config[:gmail_email]
  end

  def gmail_password
    @config[:gmail_password]
  end

  def eleetcoach_url
    @config[:eleetcoach_url]
  end

  private

  def read_config_file(config_file)
    begin
      @config = JSON.parse(File.read(config_file), symbolize_names: true)
      @logger.info { "parsed file #{config_file}" }
    rescue => err
      @logger.error { "Failed to parse config file" }
      raise "Cannot Parse Config"
    end
  end
end
