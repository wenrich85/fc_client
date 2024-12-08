defmodule FcClient.Email.ClientEmail do
  use Phoenix.Swoosh,
  template_root: "lib/fc_client_web/templates/emails",
  template_path: "welcome"

  def welcome(client, confirmation_link) do
    new()
    |> to({client.name, client.email})
    |> from({"Felicia's Cleaners", "info@feliciascleaners.com"})
    |> subject("#{client.name}, Thank you for registering!" )
    |> render_body("welcome.html", %{name: client.name, confirmation_link: confirmation_link})
    |> FcClient.Mailer.deliver()
  end


end
