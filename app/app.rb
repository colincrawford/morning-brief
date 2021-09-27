class App
  def initialize(
    logger:,
    leetcode:,
    wikipedia_algorithms:,
    mailer:,
    send_list:
  )
    @logger = logger
    @leetcode = leetcode
    @wikipedia_algorithms = wikipedia_algorithms
    @mailer = mailer
    @send_list = send_list
  end

  def run
    @logger.info { "Running Eleetcoach" }
    send_emails(
      @leetcode.random_problem,
      @wikipedia_algorithms.get_random_algorithm
    )
  end

  private

  def send_emails(problem, algorithm)
    email = AppEmail.new(leetcode_problem: problem, wikipedia_algo: algorithm)
    @send_list.each { |to| send_email(to, email) }
  end

  def send_email(to, email)
    @logger.info { "Sending problem to #{to}" }
    @mailer.send_html(
      to: to,
      from: "Eleetcoach <eleetcoach@gmail.com>",
      subject: "Daily Leetcode Problem",
      message: email.html
    )
  end
end
