class PagesController < ApplicationController
  def home
    @client_waitlist_signup = WaitlistSignupForm.new(role: "client")
    @pro_waitlist_signup    = WaitlistSignupForm.new(role: "professional")
  end

  def privacy
  end
end
