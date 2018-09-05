defmodule API.CurrenciesSyncWorker do

  import Ecto.Query, only: [from: 2]
  alias DAL.Repo
  alias DAL.Schemas.{Currency, CurrencyRate}

  def init(args) do
    {:ok, args}
  end

  def sync(startPosition \\ 1) do
    try do
      IO.puts("Sync started at position: #{startPosition}")
      response = HTTPotion.get("https://api.coinmarketcap.com/v2/ticker/?start=#{startPosition}")
      responseData = Poison.decode!(response.body)
      data = responseData["data"]
      if data != nil do
        Enum.map(data, fn {_id, currency} -> insertOrUpdate(currency) end)
        sync(startPosition + 100)
      end
    rescue
      KeyError -> "connection error" |> IO.puts
    end
  end

  defp insertOrUpdate(currency_map) do
    currency = try_load_currency_from_db(currency_map["id"])

    currency_rate_json = get_currency_rate_json(currency_map)

    if currency != nil do
      if currency.last_updated != currency_map["last_updated"] do
        currency
        |> Currency.changeset(currency_map)
        |> Repo.update()

        insert_new_currency_rate(currency_rate_json)
      end
    else
      Currency.changeset(%Currency{}, currency_map)
      |> Repo.insert()

      insert_new_currency_rate(currency_rate_json)
    end
  end


  defp get_currency_rate_json(currency_map) do
    currency_map["quotes"]["USD"]
    |> Map.put("currency_id", currency_map["id"])
  end

  defp try_load_currency_from_db(id) do
    query =
      from(
        cur in DAL.Schemas.Currency,
        where: cur.id == ^id
      )
    Repo.one(query)
  end

  defp insert_new_currency_rate(currency_rate_json) do
    CurrencyRate.changeset(%CurrencyRate{}, currency_rate_json)
    |> Repo.insert()
  end
end
