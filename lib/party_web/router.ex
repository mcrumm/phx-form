defmodule PartyWeb.Router do
  use PartyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PartyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PartyWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/contacts", ContactLive.Index, :index
    live "/contacts/new", ContactLive.Index, :new
    live "/contacts/:id/edit", ContactLive.Index, :edit

    live "/contacts/:id", ContactLive.Show, :show
    live "/contacts/:id/show/edit", ContactLive.Show, :edit

    get "/foo", PageController, :foo
    post "/foo", PageController, :create

    live "/survey", SurveyLive, :index
    live "/survey/steps/1", SurveyLive, :step_1
    live "/survey/steps/2", SurveyLive, :step_2
    live "/survey/steps/3", SurveyLive, :step_3
  end

  # Other scopes may use custom stacks.
  # scope "/api", PartyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:party, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PartyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
