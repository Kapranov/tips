defmodule Tips.WebServer do
  @moduledoc """
  Simple html render view
  """

  def index do
    :timer.sleep(100)
    "<html><h2>Crazy Nancy Pelosi Releases Bizarre Video on $15 Minimum Wage.</h2></html>"
  end
end
