defmodule Svedixer.Repo do
  use Ecto.Repo,
    otp_app: :svedixer,
    adapter: Ecto.Adapters.Postgres
end
