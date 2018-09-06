defmodule APIWeb.Test.CurrencyHelperTest do
  use ExUnit.Case, async: true
  use APIWeb.ConnCase

  alias DAL.Repo
  alias DAL.Schemas.{Currency, CurrencyRate}
  alias API.Helpers.CurrencyHelper, as: CurrencyHelper

  setup _tags do
    if (Mix.env() == :test) do
      Currency.changeset(%Currency{}, %{:symbol => "BTC", :name => "Bitcoin", :id => 1})
      |> Repo.insert()

      CurrencyRate.changeset(%CurrencyRate{}, %{:price => 7156, :currency_id => 1})
      |> Repo.insert()

      Currency.changeset(%Currency{}, %{:symbol => "ETH", :name => "Ethereum", :id => 2})
      |> Repo.insert()

      CurrencyRate.changeset(%CurrencyRate{}, %{:price => 315, :currency_id => 2})
      |> Repo.insert()
    end
    :ok
  end

  test "returns currency data by symbol" do
    {:ok, currency} = CurrencyHelper.get_currency_data_by_symbol("BTC")

    currency |> IO.inspect()

    assert currency.symbol == "BTC"
    assert currency.name == "Bitcoin"
    assert currency.id == 1
  end

  test "returns currency rate data by symbol" do
    {:ok, currency_rate} = CurrencyHelper.get_currency_rate_data_by_symbol("BTC")


  test "returns currency rate data by symbol" do
    {:ok, currency_rate} = CurrencyHelper.get_currency_rate_data_by_symbol("BTC")

    #currency_rate |> IO.inspect()

    assert currency_rate.price > 0
    assert currency_rate.currency_id == 1
  end

  test "returns clean currency data map" do
    {:ok, currency} = CurrencyHelper.get_clean_currency_data_map("BTC")

    currency |> IO.inspect()

    assert currency[:symbol] == "BTC"
    assert currency[:name] == "Bitcoin"
    assert currency[:id] == 1
  end

  test "returns clean currency rate data map" do
    {:ok, currency_rate} = CurrencyHelper.get_clean_currency_rate_data_map("BTC")

    #currency_rate |> IO.inspect()

    assert currency_rate[:price] > 0
    assert currency_rate[:currency_id] == 1
  end
end
