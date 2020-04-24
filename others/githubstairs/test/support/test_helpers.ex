defmodule Githubstairs.TestHelpers do
  @moduledoc """
  This module holds the test helpers method.
  """

  use Phoenix.ConnTest

  alias Faker.Internet
  alias Faker.Lorem
  alias Faker.Superhero
  alias Githubstairs.Repositories
  alias Githubstairs.Repositories.Repository

  Faker.start()

  @language "elixir-lang"

  @spec create_repository_fixture(any) :: map() | {:error, Ecto.Changeset.t()}
  def create_repository_fixture(attrs \\ %{}) do
    {:ok, %Repository{} = repository_created} =
      attrs
      |> Enum.into(%{
        github_repository_id: attrs[:github_repository_id] || :rand.uniform(9999),
        name: attrs[:name] || Superhero.name(),
        description: attrs[:description] || Lorem.paragraph(1..2),
        url: attrs[:url] || Internet.domain_name(),
        language: attrs[:language] || @language
      })
      |> Repositories.create()

    %{repository: repository_created}
  end
end
