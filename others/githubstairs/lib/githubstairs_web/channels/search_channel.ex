defmodule GithubstairsWeb.SearchChannel do
  use GithubstairsWeb, :channel

  alias Githubstairs.Repositories
  alias Githubstairs.Repo

  def join("search:repository", _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_search", %{"query" => search_term}, socket) do
    case length(get_repositories(search_term)) > 0 do
      true ->
        broadcast_search(socket, repositories)

        {:reply, :ok, socket}

      false ->
        broadcast_search(socket, %{})

        {:reply, {:error, :not_found, socket}
    end
  end

  def handle_in("new_search", _, socket) do
    {:noreply, socket}
  end

  defp broadcast_search(socket, payload) do
    broadcast!(socket, "new_search", %{
      repositories: GithubstairsWeb.RepositoryView.render("index.json", repositories: payload)
    })
  end

  defp get_repositories(search_term) do
    case String.length(search_term) > 0 do
      true ->
        Repositories.search(search_term)
        |> Repo.all()

      false ->
        Repositories.list()
    end
  end
end
