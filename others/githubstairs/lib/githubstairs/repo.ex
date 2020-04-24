defmodule Githubstairs.Repo do
  use Ecto.Repo,
    otp_app: :githubstairs,
    adapter: Ecto.Adapters.Postgres
end
