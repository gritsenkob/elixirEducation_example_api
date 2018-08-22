defmodule APIWeb.Router do
  use APIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", APIWeb do
    pipe_through :api

    get "/getAccount/:id", MainController, :getAccount

    post "/setAccount", MainController, :setAccount
  end
end
