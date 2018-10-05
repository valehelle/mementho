# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mementho.Repo.insert!(%Mementho.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Mementho.Accounts
alias Mementho.Forums
alias Mementho.Forums

Accounts.create_user(%{email: "hazmi@gmail.com", username: "hazmi", password: "hazmi123"})
Forums.create_group(%{slug: "new-test", user_id: 1, name: "new test", description: "This is the example of description of the group"})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "Liver", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "helo", group_id: 1, slug: "new-test", is_live: true, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "whats up", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: true, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "new post", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "whats up", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "maybe you are the one", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})
Forums.create_post(%{user_id: 1, name: "dang gidrl", group_id: 1, slug: "new-test", is_live: false, comments: [%{content: "sommen", user_id: 1}]})