defmodule Githubstairs.RepositoryTest do
  use Githubstairs.DataCase, async: true

  alias Githubstairs.Repositories.Repository

  doctest Githubstairs.Repositories.Repository

  describe "repository changeset/2" do
    @valid_parameters %{
      github_repository_id: :rand.uniform(9999),
      name: Faker.Superhero.name(),
      description: Faker.Lorem.paragraph(),
      url: Faker.Internet.domain_name(),
      language: "elixir-lang"
    }

    test "with valid parameters" do
      changeset = Repository.changeset(%Repository{}, @valid_parameters)
      assert changeset.valid?
    end

    test "without github_repository_id or description or url" do
      parameters = [:github_repository_id, :description, :url]

      Enum.each(parameters, fn param ->
        params = Map.delete(@valid_parameters, param)
        changeset = Repository.changeset(%Repository{}, params)

        refute changeset.valid?
        assert "can't be blank" in errors_on(changeset, param)
      end)
    end
  end

  describe "repository changeset_update_tags/2" do
    @valid_parameters %{
      github_repository_id: :rand.uniform(9999),
      name: Faker.Superhero.name(),
      description: Faker.Lorem.paragraph(),
      url: Faker.Internet.domain_name(),
      language: "elixir-lang",
      tags: ["elixir-lang", "erlang"]
    }

    test "with valid parameters" do
      changeset = Repository.changeset_update_tags(%Repository{}, @valid_parameters)
      assert changeset.valid?
    end

    test "without name or github_repository_id or description or url" do
      parameters = [:github_repository_id, :name, :description, :url]

      Enum.each(parameters, fn param ->
        params = Map.delete(@valid_parameters, param)
        changeset = Repository.changeset_update_tags(%Repository{}, params)

        refute changeset.valid?
        assert "can't be blank" in errors_on(changeset, param)
      end)
    end

    test "without tags" do
      params = Map.delete(@valid_parameters, :tags)
      changeset = Repository.changeset_update_tags(%Repository{}, params)

      assert changeset.valid?
    end

    test "with empty tags" do
      params = Map.put(@valid_parameters, :tags, [])
      changeset = Repository.changeset_update_tags(%Repository{}, params)

      assert changeset.valid?
    end
  end
end
