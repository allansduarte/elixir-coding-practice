defmodule Githubstairs.Repo.Migrations.CreateRepositoriesTags do
  use Ecto.Migration

  def change do
    create table(:repositories_tags, primary_key: false) do
      add(:repository_id, references(:repositories, on_delete: :delete_all), primary_key: true)
      add(:tag_id, references(:tags, on_delete: :delete_all), primary_key: true)

      timestamps()
    end

    create unique_index(:repositories_tags, [:repository_id, :tag_id])
  end
end
