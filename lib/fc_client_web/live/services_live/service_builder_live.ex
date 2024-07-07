defmodule FcClientWeb.ServicesLive.ServiceBuilderLive do
  use FcClientWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(services: CleaningBusinessModel.get_services())
  }
  end

  def render(assigns) do
    ~H"""
      <div>
      <%= inspect(@services) %>
      </div>
    """
  end
end
