defmodule LinksChecker do
  use Application

  alias Nerves.Networking
  alias Nerves.InterimWiFi

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    unless :os.type == {:unix, :darwin} do     # don't start networking unless we're on nerves
      {:ok, _} = Networking.setup :eth0
    end

    # Define workers and child supervisors to be supervised
    children = [
      worker(Gpio, [2, :output, [name: LED]]),
      worker(LinksChecker.LightControlServer, [])

    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinksChecker.Supervisor]
    process = Supervisor.start_link(children, opts)
    Quantum.add_job("* * * * *", fn -> LinksChecker.HTTPStatus.check_status("http://localhost") end)
    process
  end

end
