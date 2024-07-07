defmodule FcClientWeb.UserDashboardLive do
  use FcClientWeb, :live_view

  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <section>
        <h1> Welcome to the user dashboard!</h1>
      </section>
    """
  end
end
