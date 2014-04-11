# Configure mail to send out registration confirmations and registration cards
Pony.options = { 
  :from => 'support@yourdomain.com', 
  :via => :smtp, 
  # Contact your email provider to get theese settings or google it
  :via_options => {
    :address              => 'smtp.server.com',
    :port                 => '25',
    :enable_starttls_auto => true,
    :user_name            => 'email',
    :password             => 'password',
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
  }
}