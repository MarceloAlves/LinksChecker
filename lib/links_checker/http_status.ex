defmodule LinksChecker.HTTPStatus do
  require Logger

  def check_status(url) do
    Logger.debug "Checking URL"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 500}} ->
        LinksChecker.LightControlServer.update_status(:false)
      {:ok, %HTTPoison.Response{status_code: _}} ->
        LinksChecker.LightControlServer.update_status(:true)
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.debug "HTTP Check Error: #{reason}"
        LinksChecker.LightControlServer.update_status(:false)
    end
  end

end
