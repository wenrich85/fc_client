defmodule FcClientWeb.AboutLive do
  use FcClientWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div>
        This is our About Page.
      </div>
    """
  end
end
