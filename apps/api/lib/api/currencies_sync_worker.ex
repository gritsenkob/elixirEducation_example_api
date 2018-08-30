defmodule API.CurrenciesSyncWorker do
  use GenServer

  import Ecto.Query, only: [from: 2]

  alias DAL.Repo
  alias DAL.Schemas.{Currency, CurrencyRate}

  @spec start_link() :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  @spec init(any()) :: {:ok, any()}
  def init(stack) do
    {:ok, stack}
  end

  def handle_cast(:sync, state) do
    infiniteSync()
    {:noreply, state}
  end

  def handle_info(:sync, state) do
    infiniteSync()
    {:noreply, state}
  end

  # TODO find normal name for func
  def infiniteSync do
    #sync()
    # Reschedule once more
    schedule_sync()
  end

  def sync(startPosition \\ 1) do
    try do
      IO.puts("Sync started at position: #{startPosition}")

      response = HTTPotion.get("https://api.coinmarketcap.com/v2/ticker/?start=#{startPosition}")
      responseData = Poison.decode!(response.body)

      data = responseData["data"]
      if data != nil do
        Enum.map(data, fn {_id, currency} ->
          insertOrUpdate(currency)
        end)

        sync(startPosition + 100)
      end
    catch
      :exit, _ -> "exit blocked" |> IO.puts
    end
  end

  defp insertOrUpdate(currency_json) do
    currency = try_load_currency_from_db(currency_json["id"])

    currency_rate_json = get_currency_rate_json(currency_json)
    if currency != nil do
      if currency.last_updated != currency_json["last_updated"] do
        IO.puts("update data")

        Currency.changeset(currency, currency_json)
        |> Repo.update()

        insert_new_currency_rate(currency_rate_json)
      end
    else
      IO.puts("insert data")

      Currency.changeset(%Currency{}, currency_json)
      |> Repo.insert()

      insert_new_currency_rate(currency_rate_json)
    end
  end

  defp get_currency_rate_json(currency_json) do
    currency_json["quotes"]["USD"]
    |> Map.put("currency_id", currency_json["id"])
  end

  defp try_load_currency_from_db(id) do
    query =
      from(
        cur in DAL.Schemas.Currency,
        where: cur.id == ^id
      )
    Repo.one(query)
  end

  # TODO parse currency rate
  defp insert_new_currency_rate(currency_rate_json) do
    IO.puts("insert new currency rate")
    CurrencyRate.changeset(%CurrencyRate{}, currency_rate_json)
    |> Repo.insert()
  end


  defp schedule_sync() do
    minutes = 10
    IO.puts("Schedule sync at #{minutes} minutes")
    Process.send_after(self(), :sync, minutes * 60 * 1000)
  end

end
