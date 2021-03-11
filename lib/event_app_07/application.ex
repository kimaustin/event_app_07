defmodule EventApp07.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      EventApp07.Repo,
      # Start the Telemetry supervisor
      EventApp07Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EventApp07.PubSub},
      # Start the Endpoint (http/https)
      EventApp07Web.Endpoint
      # Start a worker by calling: EventApp07.Worker.start_link(arg)
      # {EventApp07.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventApp07.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EventApp07Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
