defmodule FcClient.Mailer do
  use Swoosh.Mailer, otp_app: :fc_client

  import Swoosh.Email

  def welcome() do
    new()
    |>to({"Wendell", "wenrich85@gmail.com"})
    |>from({"Felicia", "info@feliciascleaners.com"})
    |>subject("Test Email")
    |>text_body("This is an email test.")
    |>deliver()
  end
end
