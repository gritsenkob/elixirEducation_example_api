defmodule APIRouter do
  use Plug.Router
  require Logger

  Logger.info("Started application")

  plug(:match)
  plug(:dispatch)

  get("/", do: APIHandler.call(conn, []))
  get("/getAccount/:id", do: APIHandler.getAccount(conn, conn.path_params["id"]))
  put("/createAccount", do: APIHandler.setAccount(conn, conn.body_params))
  match(_, do: send_resp(conn, 404, "Oops!"))
end
