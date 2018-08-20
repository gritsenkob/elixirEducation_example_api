defmodule APIHandler do
  import Plug.Conn
  require Logger

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!\n")
  end


  def getAccount(conn, id) do
    account = %{ id: id, userName: "testName" <> id }
    Logger.info(Kernel.inspect(account))

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Kernel.inspect(account))
  end



  def setAccount(conn, account) do

    Logger.info(Kernel.inspect(Plug.parsers.(account, :id)))

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Kernel.inspect(fetch(account, :id)))
  end
end
