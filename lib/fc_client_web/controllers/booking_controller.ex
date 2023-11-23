defmodule FcClientWeb.BookingController do
  use FcClientWeb, :controller

  def booking(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :booking, layout: false)
  end
end
