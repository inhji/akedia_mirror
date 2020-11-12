defmodule Akedia.Webmentions.Worker do
  use Oban.Worker,
    queue: :default,
    max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"entity_id" => entity_id}}) do
    entity = Akedia.Content.get_entity!(entity_id)

    cond do
      entity.post ->
        Akedia.Webmentions.Bridgy.maybe_publish_to_github(entity.post, entity.post.reply_to)
        Akedia.Webmentions.send_webmentions(Akedia.entity_url(entity.post), ".h-entry")

      entity.like ->
        Akedia.Webmentions.Bridgy.maybe_publish_to_github(entity.like, entity.like.url)
        Akedia.Webmentions.send_webmentions(Akedia.entity_url(entity.like), ".h-entry")

      entity.bookmark ->
        Akedia.Webmentions.Bridgy.maybe_publish_to_github(entity.bookmark, entity.bookmark.url)
        Akedia.Webmentions.send_webmentions(Akedia.entity_url(entity.bookmark), ".h-entry")
    end
  end
end
