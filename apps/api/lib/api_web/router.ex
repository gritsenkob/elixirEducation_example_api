defmodule APIWeb.Router do
  use APIWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", APIWeb do
    pipe_through(:api)

    get("/getCurrency/:name", MainController, :get_currency)

    get("/getCurrencyRate/:name", MainController, :get_currency_rate)
  end
end
