defmodule LinksChecker.Light do
  require Logger

  def light_off do
    pid = Process.whereis(LED)
    Gpio.write(pid, 0)
    # Logger.debug "Light is off"
  end

  def light_on do
    pid = Process.whereis(LED)
    Gpio.write(pid, 1)
    # Logger.debug "Light is on"
  end
end
