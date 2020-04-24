defmodule Githubstairs.Repo.Migrations.CreateRepos do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :github_repository_id, :integer
      add :name, :string
      add :description, :string
      add :url, :string
      add :language, :string

      timestamps()
    end

    create unique_index(:repositories, [:github_repository_id])
  end
end
