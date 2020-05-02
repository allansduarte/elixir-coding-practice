defmodule GithubstairsWeb.Channels.SearchChannelTest do
  use GithubstairsWeb.ChannelCase
  alias GithubstairsWeb.UserSocket
  alias Githubstairs.Repositories
  alias Githubstairs.Repo
  import Githubstairs.TestHelpers

  setup do
    {:ok, socket} = connect(UserSocket, %{})
    {:ok, socket: socket}
  end

  test "join search channel", %{socket: socket} do
    {:ok, _, _socket} = subscribe_and_join(socket, "search:repository")
  end
end
