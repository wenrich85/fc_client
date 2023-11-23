defmodule FcClientWeb.AdminLive do
  use FcClientWeb, :live_view

  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    {:ok, socket |> assign(:page_title, "Admin")}
  end

  def render(assigns) do
    ~H"""
      <div>
        This is our Admin Page.
      </div>
    """
  end
end
