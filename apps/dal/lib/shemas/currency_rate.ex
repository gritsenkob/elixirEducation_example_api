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

    belongs_to(:currency, DAL.Schemas.Currency, define_field: true )

    timestamps()
  end

  @required_fields ~w(price currency_id)a
  @optional_fields ~w(volume_24h market_cap percent_change_1h percent_change_24h percent_change_7d)a

  def changeset(currencyRate, params \\ :empty) do
    currencyRate
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
  end
end
