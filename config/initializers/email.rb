# Load mail configuration if not in test environment
if RAILS_ENV != 'test'
  ActionMailer::Base.default_charset = "utf-8"
  email_settings = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  ActionMailer::Base.smtp_settings = email_settings[RAILS_ENV] unless email_settings[RAILS_ENV].nil?
end

