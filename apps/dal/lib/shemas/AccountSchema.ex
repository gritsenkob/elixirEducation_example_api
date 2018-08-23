defmodule DAL.Schemas.Account do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "account" do
      field(:username, :string)
      field(:hashed_password, :string)
      field(:email, :string)
      field(:confirmed, :boolean, default: false)
      field(:password, :string, virtual: true)
      field(:password_confirmation, :string, virtual: true)
  
      timestamps
    end
  
    @required_fields ~w(username hashed_password email)
    @optional_fields ~w()
  
    def changeset(account, params \\ :empty) do
      account
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
      |> unique_constraint(:id)
    end
  end