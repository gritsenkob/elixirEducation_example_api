defmodule QuantumPhoenix.Task do
  def work do
    API.CurrenciesSyncWorker.sync()
  end
end
