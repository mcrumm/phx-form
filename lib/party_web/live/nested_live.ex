defmodule PartyWeb.NestedLive do
  use PartyWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.form for={@form} id="nested-form" phx-change="change" phx-submit="submit">
      <.input type="text" field={@form[:event_name]} label="Title" />
      <fieldset class="my-4">
        <legend class="py-2">Guests</legend>
        <.inputs_for :let={f_nested} field={@form[:guests]}>
          <.input type="text" field={f_nested[:name]} label={"Name #{f_nested.index + 1}"} />
        </.inputs_for>
      </fieldset>
      <.button type="submit">Submit</.button>
    </.form>
    """
  end

  defmodule Guestlist do
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :event_name, :string

      embeds_many :guests, Guest do
        field :name, :string
      end
    end

    def changeset(form, params \\ %{}) do
      form
      |> cast(params, [:event_name])
      |> validate_required([:event_name])
      |> cast_embed(:guests, with: &guest_changeset/2)
    end

    def guest_changeset(guestlist, params) do
      guestlist
      |> cast(params, [:name])
      |> validate_required([:name])
    end
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    guestlist = %Guestlist{
      event_name: "My New Event",
      guests: [
        %Guestlist.Guest{name: ""},
        %Guestlist.Guest{name: ""},
        %Guestlist.Guest{name: ""}
      ]
    }

    changeset = guestlist |> Guestlist.changeset()

    {:ok,
     socket
     |> assign(:guestlist, guestlist)
     |> assign_form(changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event("change", %{"guestlist" => params}, socket) do
    changeset =
      socket.assigns.guestlist
      |> Guestlist.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("submit", %{"guestlist" => params}, socket) do
    case fake_save_guestlist(socket.assigns.guestlist, params) do
      {:ok, _guestlist} ->
        {:noreply, socket |> put_flash(:info, "Guestlist saved!") |> redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp fake_save_guestlist(%Guestlist{} = guestlist, params) do
    guestlist
    |> Guestlist.changeset(params)
    |> Ecto.Changeset.apply_action(:save)
  end
end
