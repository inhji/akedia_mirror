defmodule Akedia.Atomex do
  @moduledoc """
  Generate a valid XML string from an `Akedia.Atomex.Feed` using [xml_builder](https://github.com/joshnuss/xml_builder)
  """

  @doc """
  Build and render the document into a string.
  This is where the `<?xml version="1.0" encoding="UTF-8"?>` tag is added and where strings are escaped.

  ## Parameters

    - feed: an `Akedia.Atomex.Feed`
  """
  @spec generate_document(Akedia.Atomex.Feed.t()) :: binary()
  def generate_document(feed) do
    feed
    |> XmlBuilder.document()
    |> XmlBuilder.generate()

    # XmlBuilder.doc(feed)
  end

  @spec version() :: binary()
  def version, do: 1
end
