defmodule Party.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :developer, :boolean, default: false
    field :email, :string
    field :favorite_color, Ecto.Enum, values: [:red, :green, :blue, :purple]
    field :first_name, :string
    field :last_name, :string
    field :mobile_number, :string

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :email, :mobile_number, :favorite_color, :developer])
    |> validate_required([:first_name, :last_name, :email, :mobile_number, :favorite_color, :developer])
  end
end
