defmodule Githubstairs.TagTest do
  use Githubstairs.DataCase, async: true

  alias Githubstairs.Repositories.Tag

  doctest Githubstairs.Repositories.Tag

  describe "tag changeset/2" do
    @valid_parameters %{
      name: Faker.Superhero.name()
    }

    test "with valid parameters" do
      changeset = Tag.changeset(%Tag{}, @valid_parameters)
      assert changeset.valid?
    end

    test "without name" do
      params = Map.delete(@valid_parameters, :name)
      changeset = Tag.changeset(%Tag{}, params)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset, :name)
    end
  end
end
