Pony.options = { 
  :from => 'support@yourdomain.com',
  :via => :smtp, 
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