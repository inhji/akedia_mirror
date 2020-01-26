require Logger

current_version = Akedia.MixProject.project()[:version]
version_file = ".version"

Logger.info("================================================")
Logger.info("== AKEDIA DEPLOY SCRIPT")
Logger.info("================================================")

result =
  case File.exists?(version_file) do
    true ->
      saved_version = File.read!(version_file)
      comp = Version.compare(saved_version, current_version)

      cond do
        comp == :eq or comp == :lt ->
          {:error, "Please increase version number before deploying!"}

        comp == :gt ->
          {:ok, "Newer version found. Continuing with deploy."}

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
    Mix.Task.run("build")
    Mix.Task.run("deploy", ["--version=#{current_version}"])
    Mix.Task.run("migrate")
end
