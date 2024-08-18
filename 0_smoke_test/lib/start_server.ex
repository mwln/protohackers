defmodule Mix.Tasks.Start do
  use Mix.Task

  def run(_) do
    SmokeTest.start()
  end
end
