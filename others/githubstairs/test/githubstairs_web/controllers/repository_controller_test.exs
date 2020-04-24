defmodule Githubstairs.RepositoryControllerTest do
  use GithubstairsWeb.ConnCase, async: true

  alias Githubstairs.Repo

  describe "GET /api/repositories" do
    test "render a empty list", %{conn: conn} do
      conn = get(conn, "/api/repositories")

      assert json_response(conn, 200) == %{
               "data" => []
             }
    end

    test "render a list with data", %{conn: conn} do
      %{repository: repository_created} = create_repository_fixture()
      conn = get(conn, "/api/repositories")

      assert json_response(conn, 200) == %{
               "data" => [
                 %{
                   "github_repository_id" => repository_created.github_repository_id,
                   "name" => repository_created.name,
                   "description" => repository_created.description,
                   "id" => repository_created.id,
                   "language" => repository_created.language,
                   "tags" => [],
                   "url" => repository_created.url
                 }
               ]
             }
    end
  end

  describe "PUT /api/repositories/:id" do
    @normalized_tag "devops"
    @unnormalized_tag "devOps"

    setup do
      create_repository_fixture()
    end

    test "with valid data", %{repository: repository_created} do
      attrs = %{
        "repository" => %{
          "github_repository_id" => repository_created.github_repository_id,
          "description" => repository_created.description,
          "url" => repository_created.url,
          "language" => repository_created.language,
          "tags" => "elixir-lang, erlang"
        }
      }

      conn = put(build_conn(), "/api/repositories/#{repository_created.id}", attrs)
      repository_created = Repo.preload(repository_created, :tags)
      tag_1 = Enum.at(repository_created.tags, 0)
      tag_2 = Enum.at(repository_created.tags, 1)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "id" => repository_created.id,
                 "name" => repository_created.name,
                 "github_repository_id" => repository_created.github_repository_id,
                 "description" => repository_created.description,
                 "url" => repository_created.url,
                 "language" => repository_created.language,
                 "tags" => [
                   %{
                     "id" => tag_1.id,
                     "name" => tag_1.name
                   },
                   %{
                     "id" => tag_2.id,
                     "name" => tag_2.name
                   }
                 ]
               }
             }
    end

    test "with unnormalized tags", %{repository: repository_created} do
      attrs = %{
        "repository" => %{
          "github_repository_id" => repository_created.github_repository_id,
          "description" => repository_created.description,
          "url" => repository_created.url,
          "language" => repository_created.language,
          # keep the space in the array
          "tags" => "#{@unnormalized_tag}, , #{@unnormalized_tag}"
        }
      }

      conn = put(build_conn(), "/api/repositories/#{repository_created.id}", attrs)
      repository_created = Repo.preload(repository_created, :tags)
      tag_1 = Enum.at(repository_created.tags, 0)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "github_repository_id" => repository_created.github_repository_id,
                 "name" => repository_created.name,
                 "id" => repository_created.id,
                 "description" => repository_created.description,
                 "url" => repository_created.url,
                 "language" => repository_created.language,
                 "tags" => [
                   %{
                     "id" => tag_1.id,
                     "name" => @normalized_tag
                   }
                 ]
               }
             }
    end

    test "with empty tags", %{repository: repository_created} do
      attrs = %{
        "repository" => %{
          "github_repository_id" => repository_created.github_repository_id,
          "name" => repository_created.name,
          "description" => repository_created.description,
          "url" => repository_created.url,
          "language" => repository_created.language,
          "tags" => @normalized_tag
        }
      }

      conn = put(build_conn(), "/api/repositories/#{repository_created.id}", attrs)
      repository_created = Repo.preload(repository_created, :tags)
      tag_1 = Enum.at(repository_created.tags, 0)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "github_repository_id" => repository_created.github_repository_id,
                 "name" => repository_created.name,
                 "id" => repository_created.id,
                 "description" => repository_created.description,
                 "url" => repository_created.url,
                 "language" => repository_created.language,
                 "tags" => [
                   %{
                     "id" => tag_1.id,
                     "name" => @normalized_tag
                   }
                 ]
               }
             }

      attrs = %{
        "repository" => %{
          "github_repository_id" => repository_created.github_repository_id,
          "name" => repository_created.name,
          "description" => repository_created.description,
          "url" => repository_created.url,
          "language" => repository_created.language,
          "tags" => ""
        }
      }

      conn = put(build_conn(), "/api/repositories/#{repository_created.id}", attrs)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "github_repository_id" => repository_created.github_repository_id,
                 "name" => repository_created.name,
                 "id" => repository_created.id,
                 "description" => repository_created.description,
                 "url" => repository_created.url,
                 "language" => repository_created.language,
                 "tags" => []
               }
             }
    end

    test "without tags", %{repository: repository_created} do
      attrs = %{
        "repository" => %{
          "github_repository_id" => repository_created.github_repository_id,
          "name" => repository_created.name,
          "description" => repository_created.description,
          "url" => repository_created.url,
          "language" => repository_created.language
        }
      }

      conn = put(build_conn(), "/api/repositories/#{repository_created.id}", attrs)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "github_repository_id" => repository_created.github_repository_id,
                 "name" => repository_created.name,
                 "id" => repository_created.id,
                 "description" => repository_created.description,
                 "url" => repository_created.url,
                 "language" => repository_created.language,
                 "tags" => []
               }
             }
    end
  end

  describe "GET /api/repositories/search?query=somefilter" do
    setup %{conn: conn} do
      %{repository: repository_created} = create_repository_fixture()

      attrs = %{
        "repository" => %{
          "github_repository_id" => repository_created.github_repository_id,
          "description" => repository_created.description,
          "url" => repository_created.url,
          "language" => repository_created.language,
          "tags" => "elixir-lang"
        }
      }

      put(conn, "/api/repositories/#{repository_created.id}", attrs)

      %{repository: repository_created}
    end

    test "with existent tag", %{repository: repository_created} do
      conn = get(build_conn(), "/api/repositories/search?query=elixir")
      repository_created = Repo.preload(repository_created, :tags)
      tag_1 = Enum.at(repository_created.tags, 0)

      assert json_response(conn, 200) == %{
               "data" => [
                 %{
                   "github_repository_id" => repository_created.github_repository_id,
                   "id" => repository_created.id,
                   "name" => repository_created.name,
                   "description" => repository_created.description,
                   "url" => repository_created.url,
                   "language" => repository_created.language,
                   "tags" => [
                     %{
                       "id" => tag_1.id,
                       "name" => tag_1.name
                     }
                   ]
                 }
               ]
             }
    end

    test "with non-existent tag", %{repository: _repository_created} do
      conn = get(build_conn(), "/api/repositories/search?query=firebird")

      assert json_response(conn, 200) == %{
               "data" => []
             }
    end
  end
end
