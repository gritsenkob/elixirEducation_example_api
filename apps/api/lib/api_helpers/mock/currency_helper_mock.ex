defmodule API.Helpers.CurrencyHelperMock do
  alias DAL.Schemas.{Currency, CurrencyRate}

  @behaviour API.Helpers.CurrencyHelperBehaviour

  @spec get_currency_rate_data_by_symbol(String.t()) ::
          {:error, String.t()} | {:ok, DAL.Schemas.CurrencyRate.t()}
  def get_currency_rate_data_by_symbol(symbol) do
    case symbol do
      "BTC" -> { :ok, %CurrencyRate{ price: Decimal.new(7482), currency_id: 1 } }
      "ETH" -> { :ok, %CurrencyRate{ price: Decimal.new(315), currency_id: 2 } }
      _ -> {:error, "data not found"}
    end
  end

  @spec get_currency_data_by_symbol(String.t()) ::
          {:error, String.t()} | {:ok, DAL.Schemas.Currency.t()}
  def get_currency_data_by_symbol(symbol) do
    case symbol do
      "BTC" -> { :ok, %Currency{ symbol: "BTC", name: "Bitcoin", id: 1 } }
      "ETH" -> { :ok, %Currency{ symbol: "ETH", name: "Ethereum", id: 2 } }
      _ -> {:error, "data not found"}
    end
  end

  @spec get_clean_currency_data_map(String.t()) :: {:error, String.t()} | {:ok, map()}
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

  @spec get_clean_currency_rate_data_map(String.t()) :: {:error, String.t()} | {:ok, map()}
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
