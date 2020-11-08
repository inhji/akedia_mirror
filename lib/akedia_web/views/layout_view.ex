defmodule AkediaWeb.LayoutView do
	use AkediaWeb, :view

	def version do
		Application.spec(:akedia, :vsn)
	end

	@doc """
	Generates path for the JavaScript view we want to use
	in this combination of view/template.
	"""
	def js_view_path(conn) do
		[view_name(conn), template_name(conn)]
		|> Enum.join("/")
	end

	# Takes the resource name of the view module and removes the
	# the ending *_view* string.
	defp view_name(%{private: private} = _conn) do
		private
		|> Map.get(:phoenix_view)
		|> Phoenix.Naming.resource_name
		|> String.replace("_view", "")
	end

	# Removes the extion from the template and reutrns
	# just the name.
	defp template_name(%{private: private} = _conn) do
		private
		|> Map.get(:phoenix_template)
		|> String.split(".")
		|> Enum.at(0)
	end
end
