defmodule PartyWeb.PageController do
  use PartyWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def foo(conn, params) do
    dbg(params)
    render(conn, :foo)
  end

  def create(conn, %{"foo" => foo_params}) do
    dbg(foo_params)
    render(conn, :foo)
  end
end
