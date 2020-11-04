defmodule Akedia.Context.Worker do
	require Logger
	use Que.Worker
	alias Akedia.Content.Like
	alias Akedia.Context

	def perform(%Like{url: url, entity: entity} = _like) do
		with author_map <- Context.get_author(url),
				 content_map <- Context.get_content(url) do
			Logger.debug("Creating author..")

			{:ok, author} =
				author_map
				|> Map.drop([:photo])
				|> Akedia.Indie.maybe_create_author()

			Logger.debug("Saving author photo..")

			{:ok, author} = Akedia.Indie.update_author(author, %{photo: author_map[:photo]})

			Logger.debug("Creating context..")

			{:ok, context} =
				content_map
				|> Map.drop([:photo])
				|> Map.put_new(:author_id, author.id)
				|> Map.put_new(:entity_id, entity.id)
				|> Akedia.Indie.maybe_create_context()

			Logger.debug("Saving context photo..")

			{:ok, _context} = Akedia.Indie.update_context(context, %{photo: content_map[:photo]})
		else
			error ->
				Logger.error(inspect(error))
		end
	end
end
