require "logger"

["app", "lib"].each do |dir|
  Dir[File.join(__dir__, "..", dir, "*.rb")].sort.each do |file|
    require file
  end
end

logger = Logger.new($stdout)

config_file_flag_inx = ARGV.find_index("--config")
config_file = nil
unless config_file_flag_inx.nil?
  config_file = ARGV[config_file_flag_inx + 1]
end
config = Config.new(logger: logger, config_file: config_file)

eleetcoach = Eleetcoach::Client.new(
  logger: logger,
  base_url: config.eleetcoach_url,
  minimum_leetcode_difficulty: config.minimum_leetcode_difficulty
)
todoapp = Todoapp::Client.new(
  logger: logger,
  todoapp_url: config.todoapp_url
)
mailer = GMail.new(
  logger: logger,
  email: config.gmail_email,
  password: config.gmail_password
)
app = App.new(
  logger: logger,
  eleetcoach: eleetcoach,
  todoapp: todoapp,
  mailer: mailer,
  send_list: config.send_list
)

app.run
