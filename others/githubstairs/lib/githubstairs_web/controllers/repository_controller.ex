defmodule GithubstairsWeb.RepositoryController do
  @moduledoc """
  Endpoints for interacting with repositories.
  """

  use GithubstairsWeb, :controller

  alias Githubstairs.Repo
  alias Githubstairs.Repositories
  alias Githubstairs.Repositories.Repository

  action_fallback GithubstairsWeb.FallbackController

  @doc """
  Receives a connection to provide a repository list.
  """
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    repositories = Repositories.list()
    render(conn, "index.json", repositories: repositories)
  end

  @doc """
  Receives the data required by repository schema to create
  a new repository.
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"repository" => repository_params}) do
    with {:ok, repository} <- Repositories.create(repository_params) do
      conn
      |> put_status(:created)
      |> render("show.json", repository: repository)
    end
  end

  @doc """
  Receives the data required by repository schema to create
  a list of arepository.
  """
  def create(conn, %{"repositories" => repository_params}) do
    with {:ok, repositories} <- Repositories.create(repository_params) do
      repositories = Map.to_list(repositories)

      conn
      |> put_status(:created)
      |> render("index.json", repositories: repositories)
    end
  end

  @doc """
  Receives the data required by repository schema to update
  a new repository.
  """
  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "repository" => repository_params}) do
    repository =
      id
      |> Repositories.get_repository!()
      |> Repo.preload(:tags)

    repository_params = Map.delete(repository_params, "github_repository_id")

    with {:ok, %Repository{} = repository} <- Repositories.update(repository, repository_params) do
      render(conn, "show.json", repository: repository)
    end
  end

  @doc """
  Receives a query string to get a repository list based on it.
  """
  @spec search(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def search(conn, %{"query" => search_term}) do
    repositories =
      Repositories.search(search_term)
      |> Repo.all()

    render(conn, "index.json", repositories: repositories)
  end
end
