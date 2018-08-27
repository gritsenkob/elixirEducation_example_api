defmodule DAL.Schemas.CurrencyRate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencyRate" do
    field(:price, :decimal)
    field(:volume_24h, :decimal)
    field(:market_cap, :decimal)
    field(:percent_change_1h, :decimal)
    field(:percent_change_24h, :decimal)
    field(:percent_change_7d, :decimal)
    
    belongs_to :currnecy, DAL.Schemas.Currency

    timestamps()
  end

  @required_fields ~w(price)
  @optional_fields ~w()

  def changeset(currencyRate, params \\ :empty) do
    currencyRate
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
  end
end