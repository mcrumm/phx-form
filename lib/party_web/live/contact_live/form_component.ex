defmodule PartyWeb.ContactLive.FormComponent do
  use PartyWeb, :live_component

  alias Party.Contacts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage contact records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="contact-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="space-y-8 bg-white mt-10">
          <.input field={@form[:first_name]} type="text" label="First name" />
          <.input field={@form[:last_name]} type="text" label="Last name" />
          <.input field={@form[:email]} type="text" label="Email" />
          <.input field={@form[:mobile_number]} type="text" label="Mobile number" />
          <.input
            field={@form[:favorite_color]}
            type="select"
            label="Favorite color"
            prompt="Choose a value"
            options={Ecto.Enum.values(Party.Contacts.Contact, :favorite_color)}
          />
          <.input field={@form[:developer]} type="checkbox" label="Developer" />
          <div class="mt-2 flex items-center justify-between gap-6">
            <.button phx-disable-with="Saving...">Save Contact</.button>
          </div>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{contact: contact} = assigns, socket) do
    changeset = Contacts.change_contact(contact)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"contact" => contact_params}, socket) do
    changeset =
      socket.assigns.contact
      |> Contacts.change_contact(contact_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"contact" => contact_params}, socket) do
    save_contact(socket, socket.assigns.action, contact_params)
  end

  defp save_contact(socket, :edit, contact_params) do
    case Contacts.update_contact(socket.assigns.contact, contact_params) do
      {:ok, _contact} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contact updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_contact(socket, :new, contact_params) do
    case Contacts.create_contact(contact_params) do
      {:ok, _contact} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contact created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
