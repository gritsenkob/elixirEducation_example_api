defmodule APIWeb.MainController do
    use APIWeb, :controller
    
    def getAccount(conn, _) do
        id = conn.path_params["id"];
        json(conn, %{ id: id, name: "test" <> " " <> id})
    end

    def setAccount(conn, _) do
        json(conn, %{ id: conn.body_params["id"], name: conn.body_params["name"]})
    end
  end