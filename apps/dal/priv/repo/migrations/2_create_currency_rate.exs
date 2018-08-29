defmodule ExampleApp.Repo.Migrations.CurrecnyRate do
    use Ecto.Migration

    def change do
      create table(:currencyRate) do
        add(:price, :decimal)
        add(:volume_24h, :decimal)
        add(:market_cap, :decimal)
        add(:percent_change_1h, :decimal)
        add(:percent_change_24h, :decimal)
        add(:percent_change_7d, :decimal)
        add(:currency_id, references(:currency))

        timestamps()
      end

    end
  end
