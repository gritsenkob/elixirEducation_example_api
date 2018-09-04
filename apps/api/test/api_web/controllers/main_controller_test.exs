defmodule APIWeb.RouterTest do
  use ExUnit.Case, async: true
  #use Plug.Test
  use APIWeb.ConnCase

  alias APIWeb.Router

  @opts Router.init([])

  test "returns currency" do
    conn = build_conn()
    |> get("/api/getCurrency/BTC")

    { :ok, currency } = conn.resp_body
    |> Poison.decode()
    |> IO.inspect()

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
    |> IO.inspect()

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
    |> IO.inspect()

    assert conn.state == :sent
    assert conn.status == 200
    assert currency["symbol"] == "BTC"
    assert currency["name"] == "Bitcoin"
    assert currency["id"] == 1
    assert currency["currency_rate"]["price"] > 0
    assert currency["currency_rate"]["currency_id"] == 1
  end


  test "returns currency convertation result" do
    conn = build_conn()
    |> post("/api/calculateConvertation/", %{
      :from => "BTC",
      :to => "ETH",
      :amount => 10
    })

    { :ok, currency_convertation_result } = conn.resp_body
    |> Poison.decode()
    |> IO.inspect()

    assert conn.state == :sent
    assert conn.status == 200
    assert currency_convertation_result["from"] == "BTC"
    assert currency_convertation_result["to"] == "ETH"
    assert currency_convertation_result["from_amount"] == 10
    assert currency_convertation_result["to_amount"] > 0
    assert currency_convertation_result["to_price"] > 0
    assert currency_convertation_result["from_price"] > 0
  end

end
