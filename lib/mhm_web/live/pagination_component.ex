defmodule MhmWeb.PaginationComponent do
  use MhmWeb, :live_component

  alias MhmWeb.Forms.PaginationForm
  alias MhmWeb.Forms.PagesizeForm

  def render(assigns) do
    ~H"""
    <div class="pagination">
      <div class="page-stepper">
        <%= for {page_number, current_page?} <- pages(@pagination) do %>
          <div phx-click="show_page" phx-value-page={page_number} phx-target={@myself} class={"pagination-button #{if current_page?, do: "active"}"} >
            <%= page_number %>
          </div>
        <% end %>
      </div>


      <div>
        <.simple_form for={@form}  phx-change="set_page_size" phx-target={@myself}  >
          <.input field={@form[:page_size]} type="select" label="pageSize" options={[2, 4, 6]}
            value={@pagination[:page_size]} />
        </.simple_form>
      </div>

    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     socket
       |> assign(assigns)
       |> clear_form()}
  end


  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset, as: :hello))
  end


  @impl true
  def handle_event("show_page", params, socket) do
    parse_params(params, socket)
  end

  @impl true
  def handle_event("set_page_size", %{"hello" => params}, socket) do
    parse_params(params, socket)
  end

  defp parse_params(params, socket) do
    %{pagination: pagination} = socket.assigns

    case PaginationForm.parse(params, pagination) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def clear_form(socket) do
    assign_form(socket, PaginationForm.default_values())
  end

  def pages(%{page_size: page_size, page: current_page, total_count: total_count}) do
    page_count = ceil(total_count / page_size)

    for page <- 1..page_count//1 do
      current_page? = page == current_page

      {page, current_page?}
    end
  end


end
