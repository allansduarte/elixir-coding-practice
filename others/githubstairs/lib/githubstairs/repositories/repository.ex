defmodule Githubstairs.Repositories.Repository do
  @moduledoc """
  This module holds the database structure
  and logic for repository.
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Githubstairs.Repo
  alias Githubstairs.Repositories.Tag

  @typedoc """
    The Repository context spec type.
  """
  @type t :: %__MODULE__{}

  @repository_attrs [:github_repository_id, :name, :description, :url, :language]
  @repository_required_attrs [:github_repository_id, :name, :description, :url]
  schema "repositories" do
    field(:github_repository_id, :integer)
    field(:name, :string)
    field(:description, :string)
    field(:url, :string)
    field(:language, :string)

    many_to_many(
      :tags,
      Tag,
      join_through: Githubstairs.Repositories.RepositoriesTags,
      on_replace: :delete
    )

    timestamps()
  end

  @doc """
    Receives a map containing a raw struct for repository
    and a map of values with fields to be inserted.

      iex(1)> changeset = Githubstairs.Repositories.Repository.changeset(%Githubstairs.Repositories.Repository{}, %{
      ...(1)>   github_repository_id: 1,
      ...(1)>   name: "elixir-lang",
      ...(1)>   description: "superdescription",
      ...(1)>   url: "https://superdomain.com",
      ...(1)>   language: "elixir-lang"
      ...(1)> })
      iex(2)> changeset.valid?
      true
      iex(3)> changeset.changes
      %{
        github_repository_id: 1,
        name: "elixir-lang",
        description: "superdescription",
        language: "elixir-lang",
        url: "https://superdomain.com"
      }
  """
  @spec changeset(Githubstairs.Repositories.Repository.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = repository, attrs) do
    repository
    |> cast(attrs, @repository_attrs)
    |> validate_required(@repository_required_attrs)
    |> unique_constraint(:github_repository_id, message: "has been taken")
  end

  @doc """
    Receives a map containing a raw struct for repository
    and a map of values with fields to be updated.

      iex(1)> changeset = Githubstairs.Repositories.Repository.changeset_update_tags(%Githubstairs.Repositories.Repository{}, %{
      ...(1)>   github_repository_id: 1,
      ...(1)>   name: "elixir-lang",
      ...(1)>   description: "superdescription",
      ...(1)>   url: "https://superdomain.com",
      ...(1)>   language: "elixir-lang",
      ...(1)>   tags: ["elixir-lang", "erlang"]
      ...(1)> })
      iex(2)> changeset.valid?
      true
      iex(3)> changeset.changes
      %{
        github_repository_id: 1,
        name: "elixir-lang",
        description: "superdescription",
        language: "elixir-lang",
        url: "https://superdomain.com"
      }
  """
  @spec changeset_update_tags(Githubstairs.Repositories.Repository.t(), map()) ::
          Ecto.Changeset.t()
  def changeset_update_tags(%__MODULE__{} = repository, tags) do
    repository
    |> changeset(tags)
    |> maybe_put_tags(tags)
  end

  defp maybe_put_tags(changeset, %{"tags" => tags}) do
    tags = get_or_insert_tags(tags)
    put_assoc(changeset, :tags, tags)
  end

  defp maybe_put_tags(changeset, _), do: changeset

  defp get_or_insert_tags(tags) when is_binary(tags) do
    normalized_tags = parse_tags(tags)

    normalized_tags_to_insert =
      normalized_tags
      |> Enum.map(&%{name: &1})
      |> Enum.map(
        &Map.put(&1, :inserted_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
      )
      |> Enum.map(
        &Map.put(&1, :updated_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
      )

    Repo.insert_all(Tag, normalized_tags_to_insert, on_conflict: :nothing)

    Repo.all(from t in Tag, where: t.name in ^normalized_tags)
  end

  defp get_or_insert_tags(_), do: []

  defp parse_tags(tags) do
    tags
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.downcase/1)
  end
end
