defmodule PartyWeb.PageController do
  use PartyWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def foo(conn, _params) do
    render(conn, :foo, msg: nil, form: contact_form())
  end

  def create(conn, %{"contact" => contact_params} = params) do
    dbg(params)
    dbg(contact_params)

    render(conn, :foo,
      msg: "Received at #{System.os_time(:second) |> DateTime.from_unix!()}",
      form: contact_form(contact_params)
    )
  end

  defp contact_form(params \\ %{}) do
    Phoenix.Component.to_form(params, as: :contact)
  end
end
