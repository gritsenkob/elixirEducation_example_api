defmodule DAL.Schemas.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currency" do
    field(:name, :string)
    field(:symbol, :string)
    field(:websiteSlug, :string)
    field(:rank, :integer)
    field(:circulating_supply, :integer)
    field(:maxSupply, :integer)
    field(:sourceLastUpdated, :integer)
    
    has_many :currencyRate, DAL.Schemas.CurrencyRate

    timestamps()
  end

  @required_fields ~w(name symbol)
  @optional_fields ~w()

  def changeset(currency, params \\ :empty) do
    currency
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
  end
end