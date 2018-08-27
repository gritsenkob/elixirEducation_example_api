defmodule APIWeb.MainController do
    use APIWeb, :controller
    import Ecto.Query, only: [from: 2]

    alias DAL.Repo

    def refreshCurrency(conn, _) do
        API.CurrenciesSyncWorker.sync()
        text(conn, "ok!");
    end
  end
