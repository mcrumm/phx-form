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

    live "/nested", NestedLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PartyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard
  scope "/" do
    import Phoenix.LiveDashboard.Router

    pipe_through :browser

    live_dashboard "/dashboard", metrics: PartyWeb.Telemetry
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:party, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
