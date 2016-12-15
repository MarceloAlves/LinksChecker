defmodule LinksChecker.LightControlServer do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: :light_control_server)
  end

  def init(:ok) do
    {:ok, :true}
  end

  def handle_cast({:status, status}, state) do
    case state do
      :true ->
        LinksChecker.Light.light_off
      :false ->
        LinksChecker.Light.light_on
        :timer.sleep(1000)
        LinksChecker.Light.light_off
        :timer.sleep(1000)
        GenServer.cast(:light_control_server, {:status, status})
    end
    {:noreply, status}
  end

  def update_status(status) do
    GenServer.cast(:light_control_server, {:status, status})
  end
end
