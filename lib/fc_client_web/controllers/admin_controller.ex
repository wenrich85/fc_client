defmodule FcClientWeb.AdminController do
  use FcClientWeb, :controller

  def admin(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :admin, layout: false)
  end
end
