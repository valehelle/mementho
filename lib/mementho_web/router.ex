defmodule MementhoWeb.Router do
  use MementhoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Mementho.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, error_handler: MementhoWeb.UserController
  end

  scope "/", MementhoWeb do
  pipe_through [:browser, :auth]

  get "/", PageController, :index
  get "/users/sign_up", UserController, :register
  post "/users/sign_up", UserController, :register_user
  get "/users/sign_in", UserController, :index
  post "/users/sign_in", UserController, :login
  post "/users/sign_out", UserController, :logout
  get "/u/twitter", PostController, :twitter_url
  end

  # Definitely logged in scope
  scope "/", MementhoWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/g/new", GroupController, :new
    post "/g/new", GroupController, :create
    get "/p/:post_id/:post_slug/c/new", CommentController, :new
    get "/g/:group_id/:slug/p/new", PostController, :new
    post "/g/:group_id/:slug/p/new", PostController, :create
    get "/g/:group_id/:slug/p/live/new", PostController, :new_live
    post "/g/:group_id/:slug/p/live/new", PostController, :create_live
    delete "/g/:group_id/:group_slug/p/:post_id/:post_slug", PostController, :delete
    post "/p/:post_id/:post_slug/c/new", CommentController, :create
    get "/p/:post_id/:post_slug/c/:comment_id/r/new", CommentController, :reply_new
    post "/p/:post_id/:post_slug/c/:comment_id/r/new", CommentController, :reply_create
    get "/location", PostController, :location
    get "/dashboard", PostController, :index
    get "/chat/:name/:post_slug", PostController, :show_live_new
    get "/p/:post_id/:post_slug/live", PostController, :show_live

  end

  # Other scopes may use custom stacks.
  # scope "/api", MementhoWeb do
  #   pipe_through :api
  # end
end
