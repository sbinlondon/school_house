defmodule SchoolHouseWeb.Router do
  use SchoolHouseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SchoolHouseWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SchoolHouseWeb.RedirectPlug
    plug SchoolHouseWeb.SetLocalePlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SchoolHouseWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/blog", PostController, :index
    get "/blog/:slug", PostController, :show
    get "/blog/tag/:tag", PostController, :filter_by_tag

    get "/privacy", PageController, :privacy

    scope "/:locale" do
      get "/", PageController, :index
      get "/why", PageController, :why
      get "/get_involved", PageController, :get_involved
      get "/podcasts", PageController, :podcasts
      live "/conferences", ConferencesLive

      get "/report", ReportController, :index

      get "/:section", LessonController, :index
      get "/:section/:name", LessonController, :lesson
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SchoolHouseWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SchoolHouseWeb.Telemetry
    end
  end
end
