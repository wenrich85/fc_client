defmodule FcClientWeb.AccountManagerLive do
  alias FcClient.Accounts.User
  use FcClientWeb, :live_view
  alias FcClient.Accounts
  import __MODULE__.Components

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    socket =
      assign(socket, :users, Accounts.get_all_users)
      |> assign(:roles, [])
      |> assign_form(changeset)
    {:ok, socket}
  end

  def handle_params(_unsigned_params, uri, socket) do
    {:noreply, maybe_get_tab(socket, uri)}
  end

  def render(assigns) do
    ~H"""
    <div class=" grid gap-2 grid-cols-5">
      <!-- Sidebar -->
      <aside class="">
        <.tabs_panel account={@users} />
      </aside>

      <!-- Content -->
      <section class=" rounded-xl bg-slate-200 p-4 col-span-4">
        <!-- Tab Content -->
        <%= get_user_administration(assigns) %>
      </section>
      </div>
    """
  end

  def handle_event("save", %{"user" => %{"role" => role}, "user_id" => id}, socket) do
    {:noreply,
      socket
      |> put_flash(:info, "User with email #{id} was granted #{role} privleges")
    }
  end
  def handle_event("tab_selected", _value=%{"role" => role}, socket) do
    {:noreply,
    socket
    |> assign(:roles, set_roles(role))
    |> push_patch( to: ~p"/account-manager##{role}")
    }
  end

  defp get_user_administration(%{}=assigns) do
    ~H"""
    <.user_administration users={@users} roles={@roles} form={@form}/>
    """
  end


  defp set_roles("all"), do: [:user, :admin, :employee, :manager]
  defp set_roles("user"), do: [:user]
  defp set_roles("employee"), do: [:employee, :owner]
  defp set_roles("manager"), do: [:manager]
  defp set_roles("admin"), do: [:admin]

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end

  defp maybe_get_tab(socket, uri) do
    case String.contains?(uri, "#") do
    true -> tab =
              uri
              |> String.split("#")
              |> List.last
            assign(socket, :roles, set_roles(tab))
    _ -> socket
    end
  end

end
