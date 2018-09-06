defmodule DAL.Schemas.Currency do
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

  @required_fields ~w(name symbol)a
  @optional_fields ~w(id website_slug rank circulating_supply max_supply total_supply last_updated)a

  def changeset(currency, params \\ %{}) do
    currency
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
  end

  def sync_changeset(currency, params \\ %{}) do
    currency
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
    |> validate_update_time(params["last_updated"])
  end

  defp validate_update_time(changeset, updated_at, options \\ %{}) do
    validate_change(changeset, :last_updated, fn _, last_updated ->
      case last_updated != updated_at do
        true -> []
        false -> [{:last_updated, options[:message] || "To new to update"}]
      end
    end)
  end


end

