defmodule Mhm.Repo do
  use Ecto.Repo,
    otp_app: :mhm,
    adapter: Ecto.Adapters.Postgres
end
