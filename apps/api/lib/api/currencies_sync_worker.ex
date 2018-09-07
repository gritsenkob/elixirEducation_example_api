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
          { :ok, response } <- Poison.decode(response.body),
          { :ok, %{} = data } <- Map.fetch(response, "data") do
              data
              |> Enum.map(fn { _id, currency } -> get_changeset(currency) end)
              |> Enum.filter(fn { map, changeset } ->

                changeset |> Repo.insert_or_update()
                if changeset.changes != %{} do
                  map |> get_currency_rate_json() |> insert_new_currency_rate()
                end
              end)
            sync(startPosition + 100)
          else
            _ -> IO.puts("Data not found")
      end
    rescue
      KeyError -> "connection error" |> IO.puts
    end
  end

  defp get_changeset(currency_map) do
    result =
      case Repo.get(Currency, currency_map["id"]) do #Repo.get(Currency, currency_map["id"])
        nil -> %Currency{}
        currency -> currency
      end
      |> Currency.changeset(currency_map)

    { currency_map, result }
  end


  defp get_currency_rate_json(currency_map) do
    currency_map["quotes"]["USD"]
    |> Map.put("currency_id", currency_map["id"])
  end

  defp insert_new_currency_rate(currency_rate_json) do
    try do
      CurrencyRate.changeset(%CurrencyRate{}, currency_rate_json)
      |> Repo.insert()
    rescue
      Ecto.ConstraintError -> currency_rate_json |> IO.inspect(label: "error while insert currency rate") |> exit
    end
  end
end
