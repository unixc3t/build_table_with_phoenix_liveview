defmodule Mhm.Meerkats.Meerkat do
  use Ecto.Schema

  schema "meerkats" do
    field :name, :string
    timestamps(type: :utc_datetime)
  end
end
