defmodule ExampleApp.Repo.Migrations.Currecny do
    use Ecto.Migration

    def change do
      create table(:currency) do
        add(:name, :string, null: false, unique: true)
        add(:symbol, :string, null: false)
        add(:website_slug, :string)
        add(:rank, :integer)
        add(:circulating_supply, :decimal)
        add(:max_supply, :decimal)
        add(:total_supply, :decimal)
        add(:last_updated, :integer)

        timestamps()
      end

    end
  end
