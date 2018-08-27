defmodule API.CurrenciesSyncWorker do

  import Ecto.Query, only: [from: 2]

  alias DAL.Repo
  alias DAL.Schemas.Currency

  def sync do
    response = HTTPotion.get("https://api.coinmarketcap.com/v2/listings/")
    responseJSON = Poison.decode!(response.body, as: %{ "data" => [%DAL.Schemas.Currency{}]})

    responseJSON["data"]
    |> Enum.map(fn currency ->
      insertOrUpdate(currency)
    end)

  end

  defp insertOrUpdate(currency) do
    query =
      from(
        cur in DAL.Schemas.Currency,
        where: cur.id == ^currency.id,
        select: count(cur.id, :distinct)
      )
      count = Repo.one(query)
      if(count > 0) do
        IO.puts("update data")

        DAL.Schemas.Currency.changeset(currency)
        |> DAL.Repo.update()
      else
        IO.puts("insert data")
        DAL.Repo.insert(currency)
      end

  end
end
