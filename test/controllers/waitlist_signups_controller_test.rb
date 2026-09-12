require "test_helper"

class WaitlistSignupsControllerTest < ActionDispatch::IntegrationTest
  test "create accepts the params key form_with actually renders for the model" do
    param_key = WaitlistSignupForm.model_name.param_key

    post waitlist_signups_path,
      params: { param_key => { email: "test@example.com", role: "client" } },
      as: :turbo_stream

    assert_response :success
  end

  test "create succeeds via turbo_stream format with a valid email" do
    post waitlist_signups_path,
      params: { waitlist_signup_form: { email: "test@example.com", role: "client" } },
      as: :turbo_stream

    assert_response :success
  end
end
