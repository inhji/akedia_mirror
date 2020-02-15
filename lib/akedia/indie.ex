defmodule Akedia.Indie do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Indie.{Author, Context}

  #  $$$$$$\              $$\     $$\                           
  # $$  __$$\             $$ |    $$ |                          
  # $$ /  $$ |$$\   $$\ $$$$$$\   $$$$$$$\   $$$$$$\   $$$$$$\  
  # $$$$$$$$ |$$ |  $$ |\_$$  _|  $$  __$$\ $$  __$$\ $$  __$$\ 
  # $$  __$$ |$$ |  $$ |  $$ |    $$ |  $$ |$$ /  $$ |$$ |  \__|
  # $$ |  $$ |$$ |  $$ |  $$ |$$\ $$ |  $$ |$$ |  $$ |$$ |      
  # $$ |  $$ |\$$$$$$  |  \$$$$  |$$ |  $$ |\$$$$$$  |$$ |      
  # \__|  \__| \______/    \____/ \__|  \__| \______/ \__|      

  @doc model: :author
  def list_authors do
    Author
    |> Repo.all()
    |> Repo.preload([:author, :entity])
  end

  @doc model: :author
  def get_author!(id) do
    Author
    |> Repo.get!(id)
  end

  @doc model: :author
  def get_author_by_url(url) do
    Author |> Repo.get_by(url: url)
  end

  @doc model: :author
  def create_author(attrs \\ %{}) do
    IO.inspect("create_author")
    IO.inspect(attrs)

    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :author
  def maybe_create_author(%{url: url} = author) do
    IO.inspect("maybe_create_author")
    IO.inspect(author)

    author =
      if url == "" do
        Map.put(author, :url, "https://example.com")
      else
        author
      end

    case get_author_by_url(url) do
      nil ->
        case create_author(author) do
          {:ok, author} -> {:ok, author}
          {:error, error} -> {:error, error}
        end

      author ->
        {:ok, author}
    end
  end

  @doc model: :author
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :author
  def delete_author(%Author{} = author) do
    author
    |> Repo.delete()
  end

  #  $$$$$$\                       $$\                           $$\     
  # $$  __$$\                      $$ |                          $$ |    
  # $$ /  \__| $$$$$$\  $$$$$$$\ $$$$$$\    $$$$$$\  $$\   $$\ $$$$$$\   
  # $$ |      $$  __$$\ $$  __$$\\_$$  _|  $$  __$$\ \$$\ $$  |\_$$  _|  
  # $$ |      $$ /  $$ |$$ |  $$ | $$ |    $$$$$$$$ | \$$$$  /   $$ |    
  # $$ |  $$\ $$ |  $$ |$$ |  $$ | $$ |$$\ $$   ____| $$  $$<    $$ |$$\ 
  # \$$$$$$  |\$$$$$$  |$$ |  $$ | \$$$$  |\$$$$$$$\ $$  /\$$\   \$$$$  |
  #  \______/  \______/ \__|  \__|  \____/  \_______|\__/  \__|   \____/ 

  @doc model: :context
  def get_context!(id) do
    Context
    |> Repo.get!(id)
  end

  @doc model: :context
  def get_context_by_url(url) do
    Context |> Repo.get_by(url: url)
  end

  @doc model: :context
  def create_context(attrs \\ %{}) do
    %Context{}
    |> Context.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :context
  def maybe_create_context(%{url: url} = context) do
    case get_context_by_url(url) do
      nil ->
        case create_context(context) do
          {:ok, context} ->
            {:ok, context}

          {:error, error} ->
            {:error, error}
        end

      context ->
        {:ok, context}
    end
  end

  @doc model: :context
  def update_context(%Context{} = context, attrs) do
    context
    |> Context.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :context
  def delete_context(%Context{} = context) do
    Repo.delete(context)
  end
end
