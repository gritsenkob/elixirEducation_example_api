defmodule ExampleApp.Repo.Migrations.AccountCreate do
    use Ecto.Migration
  
    def change do
      create table(:account) do
        add(:username, :string, null: false, unique: true)
        add(:hashed_password, :string, null: false)
        add(:email, :string)
        add(:confirmed, :boolean, default: false)
  
        timestamps
      end
  
      create(unique_index(:account, [:id], name: :unique_usernames))
    end
  end