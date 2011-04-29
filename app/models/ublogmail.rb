class Ublogmail < ActionMailer::Base
  
  # Called using Ublogmail.deliver_enotify()
  # Each statement below is an instance method call
  # which sets the corresponding parameter
  def enotify (recipient, blogs)
    recipients recipient+'@#{DOMAIN}.com'
    from       'ublog@#{DOMAIN}.com'
    reply_to   'donotreply@#{DOMAIN}.com'
    subject    'ublog: update'
    sent_on    Time.now
    content_type 'text/html'
    # The body method creates an instance var
    # with the name and value specified. In this
    # case @blogs with value blogs is available
    # in the view enotify.html.erb
    body       :blogs => blogs
  end

  def nudge (home, blogs)
    recipients home.email_list+'@#{DOMAIN}.com'
    from       'ublog@#{DOMAIN}.com'
    reply_to   'donotreply@#{DOMAIN}.com'
    subject    "ublog: #{home.ublog_name} group update"
    sent_on    Time.now
    content_type 'text/html'
    # The body method creates an instance var
    # with the name and value specified. In this
    # case @blogs with value blogs is available
    # in the view enotify.html.erb
    body       :home => home, :blogs => blogs
  end
end
