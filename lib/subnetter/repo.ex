defmodule Subnetter.Repo do
  use Ecto.Repo,
    otp_app: :subnetter,
    adapter: Ecto.Adapters.Postgres
end
