defmodule Githubstairs.Repositories do
  @moduledoc """
  The Repository context.
  """

  import Ecto.Query, warn: false, only: [from: 2]

  alias Ecto.Multi
  alias Githubstairs.Repo
  alias Githubstairs.Repositories.Repository
  alias Githubstairs.Repositories.Tag

  @doc """
  Creates a repository without tags.

  ## Examples
      iex(1)> {:ok, repository_created} = Githubstairs.Repositories.create(%{
      ...(1)>   github_repository_id: 1,
      ...(1)>   name: "elixir-lang",
      ...(1)>   description: "superdescription",
      ...(1)>   url: "https://superdomain.com",
      ...(1)>   language: "elixir-lang"
      ...(1)> })
      iex(2)> repository_created.language == "elixir-lang"
      true
  """
  @spec create(map()) :: any()
  def create(attrs) when is_map(attrs) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  def create(repositories) when is_list(repositories) do
    changesets =
      Enum.map(repositories, fn repository ->
        Repository.changeset(%Repository{}, repository)
      end)

    changesets
    |> Enum.with_index()
    |> Enum.reduce(Multi.new(), fn {changeset, index}, multi ->
      Multi.insert(multi, Integer.to_string(index), changeset, on_conflict: :nothing)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a repository without tags.

  ## Examples
      iex(1)> {:ok, repository_created} = Githubstairs.Repositories.create(%{
      ...(1)>   github_repository_id: 1,
      ...(1)>   name: "elixir-lang",
      ...(1)>   description: "superdescription",
      ...(1)>   url: "https://superdomain.com",
      ...(1)>   language: "elixir-lang"
      ...(1)> })
      iex(2)> {:ok, repository_updated} = Githubstairs.Repositories.update(
      ...(2)> repository_created,
      ...(2)> %{
      ...(2)>   tags: ["elixir-lang"]
      ...(2)> })
      iex(2)> repository_updated.language == "elixir-lang"
      true
  """
  @spec update(map(), map()) :: any()
  def update(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset_update_tags(attrs)
    |> Repo.update()
  end

  @doc """
  Gets a single repository.
  Raises `Ecto.NoResultsError` if the Repository does not exist.
  ## Examples
      iex(1)> {:ok, repository_created} = Githubstairs.Repositories.create(%{
      ...(1)>   github_repository_id: 1,
      ...(1)>   name: "elixir-lang",
      ...(1)>   description: "superdescription",
      ...(1)>   url: "https://superdomain.com",
      ...(1)>   language: "elixir-lang"
      ...(1)> })
      iex(2)> repository_found = Githubstairs.Repositories.get_repository!(repository_created.id)
      iex(3)> repository_found.id == repository_created.id
      true
  """
  @spec get_repository!(integer) :: map() | {:error, Ecto.Changeset.t()}
  def get_repository!(id), do: Repo.get!(Repository, id)

  @doc """
  Returns the list of repositories.
  ## Examples
      iex(1)> {:ok, repository_created} = Githubstairs.Repositories.create(%{
      ...(1)>   github_repository_id: 1,
      ...(1)>   name: "elixir-lang",
      ...(1)>   description: "superdescription",
      ...(1)>   url: "https://superdomain.com",
      ...(1)>   language: "elixir-lang"
      ...(1)> })
      iex(2)> repository_list = Githubstairs.Repositories.list()
      iex(3)> length(repository_list) == 1
  """
  @spec list :: map() | {:error, Ecto.Changeset.t()}
  def list do
    Repo.all(Repository)
    |> Repo.preload(:tags)
  end

  @doc """
  Returns the list of found repositories.
  """
  @spec search(String.t()) :: Ecto.Query.t()
  def search(search_term) do
    wildcard_search = "%#{search_term}%"

    from repository in Repository,
      preload: [:tags],
      join: repositories_tags in "repositories_tags",
      on: repositories_tags.repository_id == repository.id,
      join: tag in Tag,
      on: tag.id == repositories_tags.tag_id,
      where: like(tag.name, ^wildcard_search),
      group_by: repository.id
  end
end
