defmodule AkediaWeb.Helpers.Markup do
  def class(expression, true_class, false_class \\ "") do
    if !!expression do
      true_class
    else
      false_class
    end
  end
end
