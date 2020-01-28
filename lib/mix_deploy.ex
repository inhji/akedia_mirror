defmodule MixDeploy do
  use ExCLI.DSL, mix_task: :deploy
  require Logger

  default_command(:deploy)

  command :deploy do
    run _context do
      version_file = ".version"

      result =
        case File.exists?(version_file) do
          false ->
            {:error, "No version file found."}

          true ->
            saved_version = File.read!(version_file)

            {:ok, saved_version, "Deploying version #{saved_version}"}
        end

      case result do
        {:error, error} ->
          Logger.error(error)

        {:ok, version, message} ->
          Logger.info(message)
          Mix.Task.run("deploy_ex", ["--version=#{version}"])
      end
    end
  end
end
