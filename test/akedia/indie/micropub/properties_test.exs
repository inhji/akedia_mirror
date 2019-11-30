defmodule Akedia.PropertiesTest do
  alias Akedia.Indie.Micropub.Properties
  use Akedia.DataCase

  @content_html %{
    "content" => [
      %{"html" => "<p>This post has <b>bold</b> and <i>italic</i> text.</p>"}
    ]
  }

  describe "Properties" do
    test "get_content/1 parses content" do
      assert Properties.get_content(@content_html) ==
               "<p>This post has <b>bold</b> and <i>italic</i> text.</p>"
    end
  end
end
