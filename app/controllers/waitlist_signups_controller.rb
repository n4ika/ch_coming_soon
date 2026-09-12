class WaitlistSignupsController < ApplicationController
  def create
    @waitlist_signup = WaitlistSignupForm.new(waitlist_signup_params)
    @role = @waitlist_signup.role

    if @waitlist_signup.valid?
      result = Klaviyo::SubscribeProfile.call(email: @waitlist_signup.email, role: @role)

      if result.success?
        @success = true
        @email = @waitlist_signup.email
      else
        @success = false
        @waitlist_signup.errors.add(:base, "Something went wrong on our end — please try again.")
      end
    else
      @success = false
    end

    respond_to do |format|
      format.turbo_stream
      format.html do
        if @success
          redirect_to root_path, notice: "You're on the list!"
        else
          redirect_to root_path, alert: @waitlist_signup.errors.full_messages.to_sentence
        end
      end
    end
  end

  private

  def waitlist_signup_params
    params.require(:waitlist_signup_form).permit(:email, :role)
  end
end
