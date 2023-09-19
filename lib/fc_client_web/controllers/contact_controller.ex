defmodule FcClientWeb.ContactController do
  use FcClientWeb, :controller

  def contact(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :contact, layout: false)
  end
end
