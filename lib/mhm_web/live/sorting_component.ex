defmodule MhmWeb.SortingComponent do
  use MhmWeb, :live_component

  def render(assigns) do
    ~H"""
      <div phx-click="sort" phx-target={@myself} >
        <%= @key %> <%= chevron(@sorting, @key) %>
      </div>
    """
  end

  def handle_event("sort", _params, socket) do
      %{sorting: %{sort_dir: sort_dir}, key: key} = socket.assigns
      sort_dir = if sort_dir == :asc, do: :desc, else: :asc
      opts = %{sort_by: key, sort_dir: sort_dir}
      send(self(), {:update, opts})
      {:noreply, assign(socket, :sorting, opts)}
  end

  def chevron(%{sort_by: sort_by, sort_dir: sort_dir}, key)
    when sort_by == key do
      if sort_dir == :asc, do: "⇧", else: "⇩"
  end

  def chevron(_opts, _key), do: ""

end
