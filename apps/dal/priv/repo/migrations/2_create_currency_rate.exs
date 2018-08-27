defmodule ExampleApp.Repo.Migrations.CurrecnyRate do
    use Ecto.Migration
  
    def change do
      create table(:currencyRate) do
        add(:price, :decimal, null: false)
        add(:volume_24h, :decimal, null: false)
        add(:market_cap, :decimal)
        add(:percent_change_1h, :decimal)
        add(:percent_change_24h, :decimal)
        add(:percent_change_7d, :decimal)
        add(:currencyId, references(:currency))

        timestamps()
      end
      
    end
  end