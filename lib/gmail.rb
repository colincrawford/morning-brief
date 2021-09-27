require "net/smtp"

class GMail
  def initialize(logger:, email:, password:)
    @from = email
    @password = password
    @smtp = Net::SMTP.new "smtp.gmail.com", 587
    @smtp.enable_starttls
  end

  def send_text(to:, from:, subject:, message:)
    message = text_content(to, from, subject, message)
    send(to, message)
  end

  def send_html(to:, from:, subject:, message:)
    message = html_content(to, from, subject, message)
    send(to, message)
  end

  private

  def send(to, message)
    @smtp.start("gmail.com", @from, @password, :plain) do |smtp|
      smtp.send_message(message, @from, to)
    end
  end

  def text_content(to, from, subject, content)
    <<~TEXT
      From: #{from}
      To: #{to}
      Subject: #{subject}

      #{content}
    TEXT
  end

  def html_content(to, from, subject, content)
    <<~HTML
      From: #{from}
      To: #{to}
      Subject: #{subject}
      MIME-Version: 1.0
      Content-type: text/html

      #{content}
    HTML
  end
end
