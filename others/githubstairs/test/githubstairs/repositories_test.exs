defmodule Githubstairs.RepositoriesTest do
  use Githubstairs.DataCase, async: true

  alias Githubstairs.Repositories

  doctest Githubstairs.Repositories

  describe "repositories create/1" do
    @valid_parameters %{
      github_repository_id: :rand.uniform(9999),
      name: Faker.Superhero.name(),
      description: Faker.Lorem.paragraph(1..2),
      url: Faker.Internet.domain_name(),
      language: "elixir-lang"
    }

    test "with valid parameters" do
      {:ok, repository_created} = Repositories.create(@valid_parameters)
      assert repository_created.github_repository_id == @valid_parameters.github_repository_id
      assert repository_created.name == @valid_parameters.name
      assert repository_created.description == @valid_parameters.description
      assert repository_created.url == @valid_parameters.url
      assert repository_created.language == @valid_parameters.language
    end

    test "without github_repository_id or description or url" do
      parameters = [:github_repository_id, :description, :url]

      Enum.each(parameters, fn param ->
        params = Map.delete(@valid_parameters, param)
        {:error, changeset} = Repositories.create(params)

        assert "can't be blank" in errors_on(changeset, param)
      end)
    end
  end

  describe "repositories update/2" do
    @valid_parameters %{
      github_repository_id: :rand.uniform(9999),
      name: Faker.Superhero.name(),
      description: Faker.Lorem.paragraph(1..2),
      url: Faker.Internet.domain_name(),
      language: "elixir-lang",
      tags: "elixir-lang, erlang"
    }

    setup do
      create_repository_fixture(@valid_parameters)
    end

    test "with valid parameters", %{repository: repository_created} do
      {:ok, repository_updated} = Repositories.update(repository_created, @valid_parameters)

      assert repository_updated.github_repository_id == @valid_parameters.github_repository_id
      assert repository_created.name == @valid_parameters.name
      assert repository_updated.description == @valid_parameters.description
      assert repository_updated.url == @valid_parameters.url
      assert repository_updated.language == @valid_parameters.language
    end
  end

  describe "repositories get_repository!/1" do
    setup do
      create_repository_fixture()
    end

    test "get a single repository", %{repository: repository_created} do
      repository_found = Repositories.get_repository!(repository_created.id)

      assert repository_found.id == repository_created.id
    end

    test "with non-existing repository", %{repository: _repository_created} do
      assert_raise Ecto.NoResultsError, fn ->
        Repositories.get_repository!(0)
      end
    end
  end

  test "check list/0" do
    create_repository_fixture()
    list_1 = Repositories.list()

    assert length(list_1) == 1

    create_repository_fixture()
    create_repository_fixture()
    list_2 = Repositories.list()

    assert length(list_2) == 3
  end
end
