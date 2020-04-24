defmodule GithubstairsWeb.SearchChannel do
  use GithubstairsWeb, :channel

  alias Githubstairs.Repositories
  alias Githubstairs.Repo

  def join("search:repository", _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_search", %{"query" => search_term}, socket) do
    repositories =
      Repositories.search(search_term)
      |> Repo.all()

    cond do
      length(repositories) > 0 ->
        broadcast!(socket, "new_search", %{
          repositories:
            GithubstairsWeb.RepositoryView.render("index.json", repositories: repositories)
        })

        {:reply, :ok, socket}

      true ->
        IO.inspect("erro na busca")
        {:noreply, socket}
        # {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_in("new_search", _, socket) do
    IO.inspect("matched")
    {:noreply, socket}
  end
end
