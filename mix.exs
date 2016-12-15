defmodule LinksChecker.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi2"

  def project do
    [app: :links_checker,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.1.4"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {LinksChecker, []},
     applications: [:logger, :httpoison, :quantum, :nerves_firmware_http, :elixir_ale,
                    :nerves_interim_wifi, :nerves_system_rpi2, :nerves, :nerves_networking]]
  end

  def deps do
    [{:nerves, "~> 0.3.0"}]
  end

  def system(target) do
    [{:"nerves_system_rpi2", github: "marceloalves/nerves_system_rpi2", branch: "rtl8192cu"},
     {:httpoison, "~> 0.9.0"},
     {:quantum, "~> 1.8"},
     {:elixir_ale, "~> 0.5.5"},
     {:nerves_firmware_http, github: "nerves-project/nerves_firmware_http"},
     {:nerves_interim_wifi, "~> 0.1.0"},
     {:nerves_networking, github: "nerves-project/nerves_networking"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
