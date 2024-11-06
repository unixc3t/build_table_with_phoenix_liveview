defmodule MhmWeb.FilterComponent do
  use MhmWeb, :live_component

  alias MhmWeb.Forms.FilterForm
  alias Mhm.Meerkats

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-submit="search" phx-target={@myself}>
        <div>
          <div>
            <.input field={@form[:id]} type="text" label="id" />
          </div>
          <div>
            <.input field={@form[:name]} type="text" label="name" />
          </div>
          <.button>search</.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
    socket
    |> assign(assigns)
    |> clear_form()}
  end

  def handle_event("search", %{"filter" => filter}, socket) do
    case FilterForm.parse(filter) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset, as: :filter))
  end

  defp clear_form(socket) do
    #%{filter: filter} = socket.assigns
    #assign_form(socket, FilterForm.change_values(filter))
    assign_form(socket, FilterForm.change_values())
  end
  #defp clear_form(socket) do
  #  IO.inspect(socket)
  #  assign_form(socket, FilterForm.change_values())
  #end
end
