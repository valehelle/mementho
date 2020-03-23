defmodule Mementho.Forums do
  @moduledoc """
  The Forums context.
  """

  import Ecto.Query, warn: false
  alias Mementho.Repo
  alias Mementho.Forums.Group

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    latest_group = from g in Group,
        order_by: [desc: g.inserted_at],
        limit: 5
    Repo.all(latest_group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id,slug) do 
    try do
      Repo.get_by!(Group, id: id, slug: slug)
      |> Repo.preload(:posts)
      |> success()
    rescue
      Ecto.NoResultsError -> {:error,"No group found"}
    end
  end
  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end
  
  defp success(data) do
    {:ok, data}
  end


  alias Mementho.Forums.Post
  alias Mementho.Forums.Comment
  @doc """
  Returns the list of posts.

  ## Examples

      iex> s()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def list_latest_posts(page, page_size) do
    latest_post = from(d in Post, limit: 10, order_by: [desc: d.inserted_at], preload: [:group, :comments])
    |> Repo.all()
  end

  def list_posts_by_group(group_id, page) do
    from(
      p in Post,
      where: p.group_id == ^group_id,
      order_by: [desc: p.last_date],
      preload: [:comments]
    )
    |> Repo.paginate(page: page, page_size: 20)


  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_comments!(id, slug) do
    Repo.get_by(Post, id: id, slug: slug)
    |> Repo.preload([comments: [:user, reply: :user]])  
  end 

  def get_post_comments_without_id!(name, slug) do
    post = %{name: name, slug: slug, is_live: true, last_date: DateTime.utc_now}
    query = from p in Post,
            where: p.slug == ^slug
      if !Repo.one(query)  do
        IO.inspect %Post{}
          |> Post.changeset(post)
          |> Repo.insert()
      end
    Repo.get_by(Post, slug: slug)
    |> Repo.preload([comments: [:user, reply: :user]])  

  end 


  def get_post!(id, slug) do
    try do
      Repo.get_by!(Post, id: id, slug: slug)
      |> success()
    rescue
      Ecto.NoResultsError -> {:error, "No post found"}
    end
  end



  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
      |> Post.changeset(attrs)
      |> Repo.insert()
  end
  
  def create_post_comment(attrs \\ %{}) do
    post = Post.changeset(%Post{}, attrs)
    Repo.insert(post)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def delete_post_id_slug(user, post_id, post_slug) do
    case get_post!(post_id, post_slug) do 
      {:ok, post} -> 
        if(post.user_id === user.id) do
          Repo.delete(post)
        else 
          {:error, "Fail to delete"}
        end
      {:error, error} -> {:error, error}
    end
  end
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(%Post{comments: [%Comment{}]})
  end

  

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end
  def list_paginate_comments(post_id, page, page_size) do
    latest_comment = from(c in Comment, where: c.post_id == ^post_id, order_by: [asc: c.inserted_at], preload: [:user, reply: :user])
    |> Repo.paginate(page: page, page_size: page_size)
  end

  def list_latest_comments(post_id) do 
    latest_comment = from c in Comment,
        order_by: [desc: c.inserted_at],
        where: c.post_id == ^post_id,
        limit: 20
    Repo.all(latest_comment)
    |> Repo.preload(:user)
  end


  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """

  def get_comment!(post_id, slug, comment_id) do
    try do
      Repo.get_by!(Comment, id: comment_id)
      |> Repo.preload([:post, :user])
      |> is_comment_from_post(post_id,slug)
    rescue
      Ecto.NoResultsError -> {:error, "Comment not found"}
    end
  end 

  defp is_comment_from_post(comment, post_id, slug) do
    case comment.post.id === String.to_integer(post_id) and comment.post.slug === slug do
      true -> {:ok,comment}
      false -> {:error, "Comment not in post"}
    end
  end
  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
