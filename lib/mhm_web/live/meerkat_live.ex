defmodule MhmWeb.MeerkatLive do
  use MhmWeb, :live_view

  alias Mhm.Meerkats
  alias MhmWeb.Forms.SortingForm
  alias MhmWeb.Forms.PaginationForm
  alias MhmWeb.Forms.FilterForm

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_meerkats()

    {:noreply, assign_meerkats(socket)}
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params),
         {:ok, filter_opts} <- FilterForm.parse(params),
         {:ok, pagination_opts} <- PaginationForm.parse(params) do
      socket
      |> assign_filter(filter_opts)
      |> assign_sorting(sorting_opts)
      |> assign_pagination(pagination_opts)
    else
      _error ->
        socket
        |> assign_sorting()
        |> assign_filter()
        |> assign_pagination()
    end
  end

  # Add this function:
  defp assign_sorting(socket, overrides \\ %{}) do
    assign(socket, :sorting, SortingForm.default_values(overrides))
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end

  defp assign_pagination(socket, overrides \\ %{}) do
    assign(socket, :pagination, PaginationForm.default_values(overrides))
  end

  defp assign_meerkats(socket) do
    params = merge_and_sanitize_params(socket)

    %{meerkats: meerkats, total_count: total_count} = Meerkats.list_meerkats_with_total_count(params)


     socket
    |> assign(:meerkats, meerkats)
    |> assign_total_count(total_count)
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{sorting: sorting, filter: filter, pagination: pagination} = socket.assigns
    overrides = maybe_reset_pagination(overrides)

    %{}
    |> Map.merge(sorting)
    |> Map.merge(pagination)
    |> Map.merge(filter)
    |> Map.merge(overrides)
    |> Map.drop([:total_count])
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp join_param(param) do
    param
    |> Enum.map(fn {key, val} ->
      if val != nil do
        "#{key}=#{val}"
      end
    end)
    |> Enum.join("&")
  end

  def handle_info({:update, opts}, socket) do
    params = merge_and_sanitize_params(socket, opts)
    a = join_param(params)
    path = ~p"/meerkat?#{a}"
    {:noreply, push_patch(socket, to: URI.decode(path), replace: true)}
  end

  defp assign_total_count(socket, total_count) do
    update(socket, :pagination, fn pagination -> %{pagination | total_count: total_count} end)
  end

   defp maybe_reset_pagination(overrides) do
    if FilterForm.contains_filter_values?(overrides) do
      Map.put(overrides, :page, 1)
    else
      overrides
    end
  end
end
