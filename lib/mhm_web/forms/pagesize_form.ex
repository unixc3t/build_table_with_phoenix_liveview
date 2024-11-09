defmodule MhmWeb.Forms.PagesizeForm do
  import Ecto.Changeset


  @fields %{
    page_size: :integer
  }

  @default_values%{
    page_size: 2
  }

  def parse(params) do
    {@default_values, @fields}
      |> cast(params, Map.keys(@fields))
      |> apply(:insert)
  end

   def change_values(values \\ @default_values) do
    {values, @fields}
    |> cast(%{}, Map.keys(@fields))
  end

  def default_values(overrides \\ %{}), do: Map.merge(@default_values, overrides)
end
