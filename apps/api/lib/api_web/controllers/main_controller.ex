defmodule APIWeb.MainController do
  use APIWeb, :controller
  import API.Helpers.CurrencyHelper

  @spec get_currency(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def get_currency(conn, params) do
    get_clean_currency_data_map(params["symbol"])
    |> case  do
      { :ok, data } -> json(conn, data)
      { :error, error } -> send_resp(conn, 500, error)
    end
  end

  @spec get_currency_rate(any(), nil | keyword() | map()) :: Plug.Conn.t()
  def get_currency_rate(conn, params) do
    params["symbol"]
    |> get_clean_currency_rate_data_map()
    |> case  do
      { :ok, data } -> json(conn, data)
      { :error, error } -> send_resp(conn, 500, error)
    end
  end

  @spec get_currency_full_data(any(), nil | keyword() | map()) :: Plug.Conn.t()
  def get_currency_full_data(conn, params) do
    with { :ok, currency_rate_data_map } <- get_clean_currency_rate_data_map(params["symbol"])
    do
      params["symbol"]
      |>get_clean_currency_data_map()
      |> case  do
        { :ok, data } ->
          data
          |> Map.put("currency_rate", currency_rate_data_map)
          |> (&json(conn, &1)).()
        { :error, error } -> send_resp(conn, 500, error)
      end
    else
      error -> error
    end
  end

  @spec calculate_convertation(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def calculate_convertation(conn, _) do
    with { :ok, from_currency } <- get_currency_rate_data_by_symbol(conn.body_params["from"]),
        { :ok, to_currency } <- get_currency_rate_data_by_symbol(conn.body_params["to"]),
        amount when is_integer(amount) <- conn.body_params["amount"],
        decimal_amount <- Decimal.new(amount),
        %Decimal{} = from_currency_price <- from_currency.price,
        %Decimal{} = to_currency_price <- to_currency.price,
        %Decimal{} = result <-
          Decimal.div(from_currency_price, to_currency.price)
          |> Decimal.mult(decimal_amount),
        %{} = view <- get_convert_currency_view(from_currency_price, to_currency_price, conn.body_params, result)
    do
      json(conn, view)
    else
      _ -> send_resp(conn, 500, "data not found")
    end
  end

  def get_convert_currency_view(from_currency_price, to_currency_price, params, to_amount) do
    %{
      :from => params["from"],
      :from_price => from_currency_price,
      :from_amount => params["amount"],
      :to => params["to"],
      :to_price => to_currency_price,
      :to_amount => to_amount
    }
  end
end
