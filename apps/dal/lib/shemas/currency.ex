defmodule DAL.Schemas.Currency do
  @derive {Poison.Encoder, except: [:__meta__, :currencyRate]}
  use Ecto.Schema
  import Ecto.Changeset

  schema "currency" do
    field(:name, :string)
    field(:symbol, :string)
    field(:website_slug, :string)
    field(:rank, :integer)
    field(:circulating_supply, :decimal)
    field(:max_supply, :decimal)
    field(:total_supply, :decimal)
    field(:last_updated, :integer)

    has_many :currencyRate, DAL.Schemas.CurrencyRate

    timestamps()
  end

  @required_fields ~w(name symbol)
  @optional_fields ~w(id website_slug rank circulating_supply max_supply total_supply last_updated)

  def changeset(currency, params \\ %{}) do
    currency
    |> cast(params, @required_fields ++ @optional_fields)
    #|> validate_required(@required_fields)
    |> unique_constraint(:id)
  end
end

