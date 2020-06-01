Clearance.configure do |config|
  config.routes = false
  config.allow_sign_up = true
  #config.mailer_sender = "reply@example.com"
  config.rotate_csrf_on_sign_in = true
end
