require "async/webdriver"

client = Async::Webdriver::Client.new endpoint: "http://localhost:9515"

# before starting ensure no "window is closed" sessions are left behind in the chromedriver
# this is because we use .first and .last in this example later on
for s in client.sessions do
  s.delete!
end

example_com_session = client.session.create!
example_com_session.navigate! "http://www.example.com"

time_is_session = client.session.create!
time_is_session.navigate! "http://www.time.is"

# another way to acess example_com_session
client.sessions.first.navigate! "http://www.reddit.com"

# another way to acess time_is_session
client.sessions.last.navigate! "http://www.twitter.com"

# close print current urls and <title>s and close all
for s in client.sessions
  puts s.url
  puts s.title
  s.delete!
  puts "--"
end
