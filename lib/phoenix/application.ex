defmodule Phoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixWeb.Telemetry,
      Phoenix.Repo,
      {DNSCluster, query: Application.get_env(:phoenix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Phoenix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Phoenix.Finch},
      # Start a worker by calling: Phoenix.Worker.start_link(arg)
      # {Phoenix.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
