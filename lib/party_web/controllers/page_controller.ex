defmodule PartyWeb.PageController do
  use PartyWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def foo(conn, params) do
    dbg(params)
    render(conn, :foo, msg: nil)
  end

  def create(conn, foo_params) do
    dbg(foo_params)

    render(conn, :foo, msg: "Received at #{System.os_time(:second) |> DateTime.from_unix!()}")
  end
end
