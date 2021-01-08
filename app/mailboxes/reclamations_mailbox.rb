class ReclamationsMailbox < ApplicationMailbox
  def process
    user_mail = mail.envelope_from
    mail_recipients = mail.recipients
    mail_title = mail.subject
    mail_date = mail.date + 14.days
    mail_body = mail.decoded
    Ticket.create(
      title: mail_title,
      description: mail_body,
      duedate: mail_date
    )
    send_cloud_api
  end

  def send_cloud_api
    user_mail = mail.envelope_from
    mail_recipients = mail.recipients
    mail_title = mail.subject
    mail_date = mail.date + 14.days
    mail_body = mail.decoded
    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://cloud.pomocedlaseniora.pl/index.php/apps/deck/api/v1.0/boards/19/stacks/64/cards")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["cookie"] = 'cookie_test=test; __cfduid=d6292f27c3efce1888584e264d708a8a61610100180; oc_sessionPassphrase=O4jje%252BSZrl67gXhX4OjOLhYRvRL%252FlG5vV90%252BROweNthuISxHuyWQOHEzt2jcQnj4RhaUmMQupmCoiMDBHHuhd64TaPbM24LE2OOvoKJ5LmVLYfEHz1U6ELYyjmhya2fD; __Host-nc_sameSiteCookielax=true; __Host-nc_sameSiteCookiestrict=true; oc1tynv43itb=a11917f36c74921c123fb0456f7c7509'
    request["content-type"] = 'application/json'
    request["ocs-apirequest"] = 'true'
    request["authorization"] = 'Basic cmVrbGFtYWNqZS1hcGk6ZmtqM3R6dFBUZzI2SGFG'
    request.body = "{\n\t\"title\": \"#{mail_title}\",\n\t\"type\": \"plain\",\n\t\"description\": \"#{mail_body}\",\n\t\"duedate\": \"#{mail_date}\"\n}"

    response = http.request(request)
    puts response.read_body
  end
end
