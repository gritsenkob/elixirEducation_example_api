defmodule APIWeb.MainController do
  use APIWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias DAL.Repo
end
