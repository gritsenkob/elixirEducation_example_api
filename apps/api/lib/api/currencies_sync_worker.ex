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
      with response <- HTTPotion.get("https://api.coinmarketcap.com/v2/ticker/?start=#{startPosition}"),
          {:ok, response} <- Poison.decode(response.body),
          {:ok, data} <- Map.fetch(response, "data") do
            changesets =
              data
              |> Enum.map(fn {_id, currency} -> get_changeset(currency) end)
              |> Enum.filter(fn { _, i } -> i.valid? end)

              insert_new_currencies(changesets)
              update_currencies(changesets)
              insert_new_currency_rates(changesets)

            changesets
            |> Enum.map(fn { map, _ } -> get_currency_rate_json(map) |> insert_new_currency_rate() end)

            sync(startPosition + 100)
          else
            _ -> require IEx;IEx.pry
      end
    rescue
      KeyError -> "connection error" |> IO.puts
    end
  end

  defp insert_new_currencies(changesets) do
    changesets
    |> Enum.filter(fn { _, i } -> i.action == :insert end)
    |> Enum.map(fn { _, changeset } -> Repo.insert(changeset) end)
  end

  defp update_currencies(changesets) do
    changesets
    |> Enum.filter(fn { _, i } -> i.action == :update end)
    |> Enum.map(fn { _, changeset } -> Repo.update(changeset) end)
  end

  defp insert_new_currency_rates(changesets) do
    changesets
    |> Enum.map(fn { map, _ } -> get_currency_rate_json(map) |> insert_new_currency_rate() end)
  end

  defp get_changeset(currency_map) do
    currency = get_currency_from_db(currency_map["id"])

    result =
      case Repo.get(Currency, currency_map["id"]) do
        nil -> %Currency{}
        currency -> currency
      end
      |> Currency.changeset(currency_map)

    { currency_map, result}
  end


  defp get_currency_rate_json(currency_map) do
    currency_map["quotes"]["USD"]
    |> Map.put("currency_id", currency_map["id"])
  end

  defp get_currency_from_db(id) do
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
