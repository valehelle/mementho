defmodule Mementho.ForumsTest do
  use Mementho.DataCase

  alias Mementho.Forums

  describe "groups" do
    alias Mementho.Forums.Group

    @valid_attrs %{name: "some name", url: "some url"}
    @update_attrs %{name: "some updated name", url: "some updated url"}
    @invalid_attrs %{name: nil, url: nil}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forums.create_group()

      group
    end

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Forums.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Forums.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Forums.create_group(@valid_attrs)
      assert group.name == "some name"
      assert group.url == "some url"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forums.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, group} = Forums.update_group(group, @update_attrs)
      assert %Group{} = group
      assert group.name == "some updated name"
      assert group.url == "some updated url"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Forums.update_group(group, @invalid_attrs)
      assert group == Forums.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Forums.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Forums.change_group(group)
    end
  end

  describe "posts" do
    alias Mementho.Forums.Post

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forums.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Forums.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Forums.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Forums.create_post(@valid_attrs)
      assert post.name == "some name"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forums.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Forums.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.name == "some updated name"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Forums.update_post(post, @invalid_attrs)
      assert post == Forums.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Forums.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Forums.change_post(post)
    end
  end

  describe "comments" do
    alias Mementho.Forums.Comment

    @valid_attrs %{content: "some content", reply_content: "some reply_content", reply_to: 42}
    @update_attrs %{content: "some updated content", reply_content: "some updated reply_content", reply_to: 43}
    @invalid_attrs %{content: nil, reply_content: nil, reply_to: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forums.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Forums.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Forums.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Forums.create_comment(@valid_attrs)
      assert comment.content == "some content"
      assert comment.reply_content == "some reply_content"
      assert comment.reply_to == 42
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forums.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Forums.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.content == "some updated content"
      assert comment.reply_content == "some updated reply_content"
      assert comment.reply_to == 43
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Forums.update_comment(comment, @invalid_attrs)
      assert comment == Forums.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Forums.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Forums.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Forums.change_comment(comment)
    end
  end
end
