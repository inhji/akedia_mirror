defmodule AkediaWeb.MentionView do
  use AkediaWeb, :view

  def mention_action(mention) do
    case mention.wm_property do
      "like-of" -> "liked"
      "in-reply-to" -> "wrote a comment on"
      "bookmark-of" -> "bookmarked"
      action -> action
    end
  end

  def mention_target_path(mention) do
    mention.target
    |> URI.parse()
    |> Map.get(:path)
  end
end
