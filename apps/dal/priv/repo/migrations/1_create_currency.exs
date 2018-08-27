defmodule ExampleApp.Repo.Migrations.Currecny do
    use Ecto.Migration
  
    def change do
      create table(:currency) do
        add(:name, :string, null: false, unique: true)
        add(:symbol, :string, null: false)
        add(:websiteSlug, :string)
        add(:rank, :integer)
        add(:circulating_supply, :integer)
        add(:maxSupply, :integer)
        add(:sourceLastUpdated, :integer)

        timestamps()
      end
  
    end
  end