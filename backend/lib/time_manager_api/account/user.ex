defmodule TimeManagerApi.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:role_id, :integer, default: 1)
    field(:username, :string)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role_id])
    |> validate_required([:username, :email, :password, :role_id])
    |> validate_format(:email, ~r/[a-z0-9]+@[a-z0-9]+.[a-z0-9]+/)
    |> unique_constraint(:user, [:username, :email])
    |> validate_length(:password, min: 8)
    |> encrypt_password()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role_id])
    |> validate_format(:email, ~r/[a-z0-9]+@[a-z0-9]+.[a-z0-9]+/)
    |> unique_constraint(:user, [:username, :email])
    |> validate_length(:password, min: 8)
    |> encrypt_password()
  end

  defp encrypt_password(user) do
    password = fetch_field!(user, :password)

    case password do
      nil ->
        user

      _ ->
        encrypted_password = Bcrypt.Base.hash_password(password, Bcrypt.Base.gen_salt(12, true))
        put_change(user, :password_hash, encrypted_password)
    end
  end
end
