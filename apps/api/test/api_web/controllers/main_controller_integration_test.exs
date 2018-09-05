defmodule APIWeb.MainControllerIntegrationTest do
  use ExUnit.Case, async: true
  #use Plug.Test
  use APIWeb.ConnCase

  alias DAL.Repo
  alias DAL.Schemas.{Currency, CurrencyRate}

  @moduletag :integration_test

  setup _tags do

    Currency.changeset(%Currency{}, %{ :symbol => "BTC", :name => "Bitcoin", :id => 1 })
    |> Repo.insert()

    CurrencyRate.changeset(%CurrencyRate{}, %{ :price => 7156, :currency_id => 1 })
    |> Repo.insert()


    Currency.changeset(%Currency{}, %{ :symbol => "ETH", :name => "Ethereum", :id => 2 })
    |> Repo.insert()

    CurrencyRate.changeset(%CurrencyRate{}, %{ :price => 315, :currency_id => 2 })
    |> Repo.insert()

    :ok
  end

  test "returns currency" do
    conn = build_conn()
    |> get("/api/getCurrency/BTC")

    { :ok, currency } = conn.resp_body
    |> Poison.decode()
    #|> IO.inspect()

    assert conn.state == :sent
    assert conn.status == 200
    assert currency["symbol"] == "BTC"
    assert currency["name"] == "Bitcoin"
    assert currency["id"] == 1
  end


  test "returns currency rate" do
    conn = build_conn()
    |> get("/api/getCurrencyRate/BTC")

    { :ok, currency } = conn.resp_body
    |> Poison.decode()
    #|> IO.inspect()

    assert conn.state == :sent
    assert conn.status == 200
    assert currency["price"] > 0
    assert currency["currency_id"] == 1
  end

  test "returns currency full data" do
    conn = build_conn()
    |> get("/api/getCurrencyFullData/BTC")

    { :ok, currency } = conn.resp_body
    |> Poison.decode()
    #|> IO.inspect()

    assert conn.state == :sent
    assert conn.status == 200
    assert currency["symbol"] == "BTC"
    assert currency["name"] == "Bitcoin"
    assert currency["id"] == 1
    assert currency["currency_rate"]["price"] > 0
    assert currency["currency_rate"]["currency_id"] == 1
  end


  test "returns currency convertation result" do
    from_amount = 10

    conn = build_conn()
    |> post("/api/calculateConvertation/", %{
      :from => "BTC",
      :to => "ETH",
      :amount => from_amount
    })

    { :ok, currency_convertation_result } = conn.resp_body
    |> Poison.decode()
    #|> IO.inspect()

    assert conn.state == :sent
    assert conn.status == 200
    assert currency_convertation_result["from"] == "BTC"
    assert currency_convertation_result["to"] == "ETH"
    assert currency_convertation_result["from_amount"] == from_amount
    assert currency_convertation_result["to_amount"] > 0
    assert currency_convertation_result["to_price"] > 0
    assert currency_convertation_result["from_price"] > 0
  end

end
