defmodule FcClientWeb.ServicesController do
  use FcClientWeb, :controller

  def services(conn, _params) do
    render(conn, :services, layout: false)
  end


end
