defmodule AkediaWeb.ErrorView do
  use AkediaWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("500.html", _assigns) do
    ~E"""
    <html>
      <head><title>666 Infernal Server Error</title></head>
      <body bgcolor="white">
        <center><h1>666 Infernal Server Error</h1></center>
        <hr><center>nginx/6.6.6 (Satanic Linux)</center>
      </body>
    </html>
    """
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
