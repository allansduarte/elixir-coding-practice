defmodule GithubstairsWeb.Channels.UserSocketTest do
  use GithubstairsWeb.ChannelCase, async: true
  alias GithubstairsWeb.UserSocket

  test "socket connect" do
    assert {:ok, socket} = connect(UserSocket, %{})
  end
end
