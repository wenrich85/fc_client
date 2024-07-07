defmodule FcClientWeb.AboutLive do
  use FcClientWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(:page_title, "About")
    |> assign(:company_info, CleaningBusinessModel.get_business())
  }
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= @company_info.title %>
      </div>
    """
  end
end
