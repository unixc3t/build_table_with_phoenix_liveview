defmodule Mhm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MhmWeb.Telemetry,
      Mhm.Repo,
      {DNSCluster, query: Application.get_env(:mhm, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mhm.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mhm.Finch},
      # Start a worker by calling: Mhm.Worker.start_link(arg)
      # {Mhm.Worker, arg},
      # Start to serve requests, typically the last entry
      MhmWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mhm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MhmWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
