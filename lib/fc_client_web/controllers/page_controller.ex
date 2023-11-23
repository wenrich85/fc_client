defmodule FcClientWeb.PageController do
  use FcClientWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(
      conn
      |> assign(:page_title, "Home"),
      :home,
      layout: false)
  end
end
