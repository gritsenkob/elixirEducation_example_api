defmodule APIWeb.Router do
  use APIWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", APIWeb do
    pipe_through(:api)

    get("/getCurrency/:symbol", MainController, :get_currency)

    get("/getCurrencyRate/:symbol", MainController, :get_currency_rate)

    get("/getCurrencyFullData/:symbol", MainController, :get_currency_full_data)

    post("/calculateConvertation/", MainController, :calculate_convertation)
  end
end
