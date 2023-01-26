defmodule Party.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Party.Contacts` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        developer: true,
        email: "some email",
        favorite_color: :red,
        first_name: "some first_name",
        last_name: "some last_name",
        mobile_number: "some mobile_number"
      })
      |> Party.Contacts.create_contact()

    contact
  end
end
