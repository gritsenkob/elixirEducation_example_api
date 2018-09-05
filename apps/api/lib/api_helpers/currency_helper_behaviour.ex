defmodule API.Helpers.CurrencyHelperBehaviour do
  @callback get_currency_rate_data_by_symbol(String.t()) ::
  {:error, string} | {:ok, DAL.Schemas.CurrencyRate.t()}


  @callback get_currency_data_by_symbol(String.t()) ::
          {:error, String.t()} | {:ok, DAL.Schemas.Currency.t()}

  @callback get_clean_currency_data_map(String.t()) :: {:error, String.t()} | {:ok, map()}

  @callback get_clean_currency_rate_data_map(String.t()) :: {:error, String.t()} | {:ok, map()}
end
