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
      <div class="service-card">
       <p> Service cards with price </p>
      </div>
      <div>
       <p class="service-list"> List of Services </p>
      </div>
    """
  end

end
