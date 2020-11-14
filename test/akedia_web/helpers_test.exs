defmodule AkediaWeb.HelpersTest do
  use Akedia.SimpleCase
  alias AkediaWeb.Helpers.Markup

  describe "Markup" do
    test "class/3 returns true class if expression is truthy" do
      assert Markup.class(true, "is-true", "is-false") == "is-true"
      assert Markup.class("yeah", "is-true", "is-false") == "is-true"
    end

    test "class/3 returns false class if expression is falsy" do
      assert Markup.class(nil, "is-true", "is-false") == "is-false"
      assert Markup.class(false, "is-true", "is-false") == "is-false"
    end
  end
end
