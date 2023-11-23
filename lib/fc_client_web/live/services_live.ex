defmodule FcClientWeb.ServicesLive do
  use FcClientWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(:page_title, "Our Services")
  }
  end

  def render(assigns) do
    ~H"""
      <div>
        List of services. with tabs for each or columns with comparison depends on screen size
      </div>
    """
  end
end
