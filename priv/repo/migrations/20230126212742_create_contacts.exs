defmodule Party.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :mobile_number, :string
      add :favorite_color, :string
      add :developer, :boolean, default: false, null: false

      timestamps()
    end
  end
end
