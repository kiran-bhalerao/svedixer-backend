defmodule SvedixerWeb.Router do
  use SvedixerWeb, :router
  alias Svedixer.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Guardian.AuthPipeline
  end

  # public scope
  scope "/api/v1", SvedixerWeb do
    pipe_through(:api)

    ## User resources
    post "/sign_up", UserController, :sign_up
    post "/sign_in", UserController, :sign_in

    ## Post resources
    get "/posts/:id", PostController, :show
    get "/feed", PostController, :home_feed
    get "/feed/:user_id", PostController, :user_feed
  end

  # private scope
  scope "/api/v1", SvedixerWeb do
    pipe_through [:api, :protected]

    ## User resources
    get "/me", UserController, :me

    ## Post resources
    post "/posts", PostController, :create
    put "/posts/:id", PostController, :update
    delete "/posts/:id", PostController, :delete

    ## Like resources
    post "/like/:post_id", LikeController, :create
    delete "/like/:id", LikeController, :delete

    ## comment resources
    post "/comment", CommentController, :create
    put "/comment/:id", CommentController, :update
    delete "/comment/:id", CommentController, :delete
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: SvedixerWeb.Telemetry
    end
  end
end
