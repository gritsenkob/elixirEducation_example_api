defmodule API.CurrenciesSyncWorker do

  def start_link() do
    sync()
  end

  def sync do
    IO.puts("World")

    #Process.send_after(self(), :sync, 1000)
    
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent
    }
  end
end