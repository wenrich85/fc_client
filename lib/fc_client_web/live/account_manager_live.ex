defmodule FcClientWeb.AccountManagerLive do
  use FcClientWeb, :live_view
  alias FcClient.Accounts

  def mount(_params, session, socket) do
    socket = assign(socket, :users, Accounts.get_all_users)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= for user <- assigns.users do %>
        <%= if user.role == :admin do %>
        <p> <%= user.name %> </p>
        <% end %>
        <% end %>
    </div>
    """
  end
end
