defmodule Party.ContactsTest do
  use Party.DataCase

  alias Party.Contacts

  describe "contacts" do
    alias Party.Contacts.Contact

    import Party.ContactsFixtures

    @invalid_attrs %{developer: nil, email: nil, favorite_color: nil, first_name: nil, last_name: nil, mobile_number: nil}

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Contacts.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Contacts.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      valid_attrs = %{developer: true, email: "some email", favorite_color: :red, first_name: "some first_name", last_name: "some last_name", mobile_number: "some mobile_number"}

      assert {:ok, %Contact{} = contact} = Contacts.create_contact(valid_attrs)
      assert contact.developer == true
      assert contact.email == "some email"
      assert contact.favorite_color == :red
      assert contact.first_name == "some first_name"
      assert contact.last_name == "some last_name"
      assert contact.mobile_number == "some mobile_number"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      update_attrs = %{developer: false, email: "some updated email", favorite_color: :green, first_name: "some updated first_name", last_name: "some updated last_name", mobile_number: "some updated mobile_number"}

      assert {:ok, %Contact{} = contact} = Contacts.update_contact(contact, update_attrs)
      assert contact.developer == false
      assert contact.email == "some updated email"
      assert contact.favorite_color == :green
      assert contact.first_name == "some updated first_name"
      assert contact.last_name == "some updated last_name"
      assert contact.mobile_number == "some updated mobile_number"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_contact(contact, @invalid_attrs)
      assert contact == Contacts.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Contacts.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Contacts.change_contact(contact)
    end
  end
end
