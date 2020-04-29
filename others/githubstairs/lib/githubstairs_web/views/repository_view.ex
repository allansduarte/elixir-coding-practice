defmodule GithubstairsWeb.RepositoryView do
  use GithubstairsWeb, :view

  def render("index.json", %{repositories: repositories}) do
    %{data: render_many(repositories, __MODULE__, "repository.json")}
  end

  def render("show.json", %{repository: repository}) do
    %{data: render_one(repository, __MODULE__, "repository.json")}
  end

  def render("repository.json", %{repository: repository}) when is_map(repository) do
    if Kernel.map_size(repository) > 0 do
      do_render_repository(repository)
    else
      %{}
    end
  end

  def render("repository.json", %{repository: repository_tuple})
      when is_tuple(repository_tuple) do
    {_, repository} = repository_tuple

    %{
      id: repository.id,
      github_repository_id: repository.github_repository_id,
      name: repository.name,
      description: repository.description,
      url: repository.url,
      language: repository.language,
      tags:
        if(Ecto.assoc_loaded?(repository.tags),
          do: render_many(repository.tags, __MODULE__, "tags.json", as: :tags),
          else: []
        )
    }
  end

  def render("tags.json", %{tags: tags}) do
    %{
      id: tags.id,
      name: tags.name
    }
  end

  defp do_render_repository(repository) do
    %{
      id: repository.id,
      github_repository_id: repository.github_repository_id,
      name: repository.name,
      description: repository.description,
      url: repository.url,
      language: repository.language,
      tags:
        if(Ecto.assoc_loaded?(repository.tags),
          do: render_many(repository.tags, __MODULE__, "tags.json", as: :tags),
          else: []
        )
    }
  end
end
