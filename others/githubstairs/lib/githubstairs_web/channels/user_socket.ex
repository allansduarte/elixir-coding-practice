defmodule GithubstairsWeb.UserSocket do
  use Phoenix.Socket

  channel("search:repository", GithubstairsWeb.SearchChannel)

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
