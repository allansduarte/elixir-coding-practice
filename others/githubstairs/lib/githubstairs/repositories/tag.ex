defmodule Githubstairs.Repositories.Tag do
  @moduledoc """
  This module holds the database structure
  and logic for tag.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Githubstairs.Repositories.Repository

  @typedoc """
    The Tag context spec type.
  """
  @type t :: %__MODULE__{}

  @tag_attrs [:name]

  schema "tags" do
    field :name, :string

    many_to_many(
      :repositories,
      Repository,
      join_through: Githubstairs.Repositories.RepositoriesTags,
      on_replace: :delete
    )

    timestamps()
  end

  @doc """
    Receives a map containing a raw struct for tag
    and a map of values with fields to be inserted.

      iex(1)> changeset = Githubstairs.Repositories.Tag.changeset(%Githubstairs.Repositories.Tag{}, %{
      ...(1)> name: "supertag"
      ...(1)> })
      iex(2)> changeset.valid?
      true
      iex(3)> changeset.changes
      %{name: "supertag"}
  """
  @spec changeset(Githubstairs.Repositories.Tag.t(), map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = tag, attrs) do
    tag
    |> cast(attrs, @tag_attrs)
    |> validate_required(@tag_attrs)
    |> unique_constraint(:name, message: "has been taken")
  end
end
