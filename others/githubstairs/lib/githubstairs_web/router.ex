defmodule GithubstairsWeb.Router do
  use GithubstairsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GithubstairsWeb do
    pipe_through :api

    get "/repositories/search", RepositoryController, :search
    resources "/repositories", RepositoryController, only: [:index, :create, :update]
  end

  scope "/", GithubstairsWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
