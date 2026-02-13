class CustomDeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    opts[:subject] = "Reset password instructions for #{ENV.fetch("HOST", "URL Shortener")}"
    super
  end
end
