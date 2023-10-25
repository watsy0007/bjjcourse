defmodule Bjjcourse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BjjcourseWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:bjjcourse, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bjjcourse.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bjjcourse.Finch},
      # Start a worker by calling: Bjjcourse.Worker.start_link(arg)
      # {Bjjcourse.Worker, arg},
      # Start to serve requests, typically the last entry
      BjjcourseWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bjjcourse.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BjjcourseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
