class App
  def initialize(
    logger:,
    eleetcoach:,
    todoapp:,
    mailer:,
    send_list:
  )
    @logger = logger
    @eleetcoach = eleetcoach
    @todoapp = todoapp
    @mailer = mailer
    @send_list = send_list
  end

  def run
    @logger.info { "Running MorningBrief" }
    send_emails(
      @eleetcoach.leetcode_problem,
      @eleetcoach.wikipedia_algorithm,
      @todoapp.todos
    )
  end

  private

  def send_emails(problem, algorithm, todos)
    email = AppEmail.new(
      leetcode_problem: problem,
      wikipedia_algo: algorithm,
      todos: todos
    )
    @send_list.each { |to| send_email(to, email) }
  end

  def send_email(to, email)
    @logger.info { "Sending morning email to #{to}" }
    @mailer.send_html(
      to: to,
      from: "Morning Brief <eleetcoach@gmail.com>",
      subject: "Morning Brief",
      message: email.html
    )
  end
end
