defmodule FcClient.Repo do
  use Ecto.Repo,
    otp_app: :fc_client,
    adapter: Ecto.Adapters.Postgres
end
