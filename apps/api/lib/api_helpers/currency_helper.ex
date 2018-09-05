defmodule API.Helpers.CurrencyHelper do
  import Ecto.Query, only: [from: 2]

  alias DAL.Repo
  alias DAL.Schemas.{Currency, CurrencyRate}

  @spec get_currency_rate_data_by_symbol(any()) ::
          {:error, string} | {:ok, DAL.Schemas.CurrencyRate.t()}
  def get_currency_rate_data_by_symbol(symbol) do
    from(
      currency_rate in CurrencyRate,
      join: currency in Currency,
      on: currency_rate.currency_id == currency.id,
      where: currency.symbol == ^symbol,
      order_by: [desc: currency_rate.inserted_at],
      limit: 1,
      select: currency_rate
    )
    |> Repo.one()
    |> case do
      %CurrencyRate{} = result -> {:ok, result}
      _ -> {:error, "data not found"}
    end
  end

  @spec get_currency_data_by_symbol(any()) ::
          {:error, string} | {:ok, DAL.Schemas.Currency.t()}
  def get_currency_data_by_symbol(symbol) do
    from(currency in Currency, where: currency.symbol == ^symbol)
    |> Repo.one()
    |> case do
      %Currency{} = result -> {:ok, result}
      _ -> {:error, "data not found"}
    end
  end

  @spec get_clean_currency_data_map(any()) :: {:error, string} | {:ok, map()}
  def get_clean_currency_data_map(symbol) do
    symbol
    |> get_currency_data_by_symbol()
    |> case do
      {:ok, data} ->
        data
        |> Map.from_struct()
        |> Map.drop([:__meta__, :currencyRate])
        |> ok_with_data()

      {:error, error} ->
        {:error, error}
    end
  end

  @spec get_clean_currency_rate_data_map(any()) :: {:error, string} | {:ok, map()}
  def get_clean_currency_rate_data_map(symbol) do
    get_currency_rate_data_by_symbol(symbol)
    |> case do
      {:ok, data} ->
        data
        |> Map.from_struct()
        |> Map.drop([:__meta__, :currency])
        |> ok_with_data()

      {:error, error} ->
        {:error, error}
    end
  end

  defp ok_with_data(data), do: {:ok, data}

end
