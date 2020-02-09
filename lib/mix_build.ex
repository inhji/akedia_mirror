defmodule MixBuild do
  use ExCLI.DSL, mix_task: :build
  require Logger

  default_command(:build)

  command :build do
    run _context do
      current_version = Akedia.MixProject.project()[:version]
      version_file = ".version"

      result =
        case File.exists?(version_file) do
          true ->
            saved_version = File.read!(version_file)
            comp = Version.compare(current_version, saved_version)

            cond do
              comp == :gt ->
                File.write!(version_file, current_version)
                {:ok, "Newer version [${current_version}] found. Continuing with deploy."}

              comp == :eq or comp == :lt ->
                {:error, "Please increase version number before deploying!"}

              true ->
                {:error, "WAT?"}
            end

          false ->
            File.write!(version_file, current_version)

            {:ok, "No version file found. Creating and continuing with deploy."}
        end

      case result do
        {:error, error} ->
          Logger.error(error)

        {:ok, message} ->
          Logger.info(message)
          Mix.Task.run("build_ex")
      end
    end
  end
end
