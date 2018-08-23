defmodule APIWeb.MainController do
    use APIWeb, :controller
    import Ecto.Query, only: [from: 2]
    
    alias DAL.Repo
    alias DAL.Schemas.Account

    def getAccount(conn, _) do

        id = conn.path_params["id"];
        query =
        from(
            u in Account,
            where: u.id == ^id,
            select: u
        )

        account = Repo.one(query)

        IO.puts(inspect(account))

        json(conn, %{ id: id, name: account.username, email: account.email})
    end

    def setAccount(conn, _) do
        params = conn.body_params
        account = Repo.insert!(%Account{ username: params["username"], email: params["email"], hashed_password: "testPassword" })
        IO.puts(inspect(account.id))

        json(conn, %{ result: "ok", id: account.id })
    end
  end