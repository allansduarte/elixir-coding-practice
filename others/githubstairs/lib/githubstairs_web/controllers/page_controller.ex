defmodule GithubstairsWeb.PageController do
  use GithubstairsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
