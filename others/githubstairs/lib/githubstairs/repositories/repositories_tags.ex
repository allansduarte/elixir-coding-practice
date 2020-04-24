defmodule Githubstairs.Repositories.RepositoriesTags do
  @moduledoc """
  This module holds the database structure
  and logic for relationship between tag and repository.
  """

  use Ecto.Schema

  # import Ecto.Changeset

  # @repositories_tags_attrs [:repository_id, :tag_id]

  @primary_key false
  schema "repositories_tags" do
    belongs_to :repository, Githubstairs.Repositories.Repository
    belongs_to :tag, Githubstairs.Repositories.Tag

    timestamps()
  end

  # def changeset(%__MODULE__{} = repositories_tags, attrs) do
  #   repositories_tags
  #   |> cast(attrs, @repositories_tags_attrs)
  #   |> validate_required(@repositories_tags_attrs)
  # end
end
