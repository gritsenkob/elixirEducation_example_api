defmodule APIWeb.MainController do
  use APIWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias DAL.Repo
  alias DAL.Repo
  alias DAL.Schemas.{Currency, CurrencyRate}

  @spec get_currency(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def get_currency(conn, params) do
    query = from(currency in Currency, where: currency.symbol == ^params["name"])
    Repo.one(query)
    |> Map.from_struct
    |> Map.drop([:__meta__, :currencyRate])
    |> (&json(conn, &1)).()
  end

  def get_currency_rate(conn, params) do
    query = from(
        currency_rate in CurrencyRate,
        join: currency in Currency, on: currency_rate.currency_id == currency.id,
        where: currency.symbol == ^params["name"],
        order_by: [desc: currency.last_updated],
        limit: 1,
        select: currency_rate
      )
    Repo.one(query)
    |> Map.from_struct
    |> Map.drop([:__meta__, :currency])
    |> (&json(conn, &1)).()
  end

end
