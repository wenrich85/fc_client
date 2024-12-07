defmodule FcClientWeb.Organization.OrganizationLive do
      alias FcClient.Organization
  use FcClientWeb, :live_view

  alias FcClient.Organization.Position

  def render(assigns) do
    ~H"""
      <div>

      <h1 :if={@active_parent > 0} class="text-center text-3xl"> <%= get_active_parent(@positions, @active_parent) %> Direct Reports </h1>

        <.modal id="position_modal">
        <.simple_form
        for={@form}
        id="position_form"
        phx-submit="save"
        phx-change="validate"
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:title]} type="text" label="Title" required />
        <.input field={@form[:description]} type="text" label="Description" required />
        <%= if(length(@parents) > 0 ) do %>
          <.input field={@form[:parent]} type="select" label="Parent" options={@parents} required />
        <% end %>
        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Add a position</.button>
        </:actions>
      </.simple_form>
      </.modal>

      <.button phx-click = {show_modal("position_modal")}> Add Position </.button>

      <p :if={@active_parent > 0} class="m-auto cursor-pointer text-light-blue-vivid-500" phx-click="dec_parent">  <.icon name="hero-backward-solid" class="h-5 w-5" />  Go back to <%= get_active_parent(@positions, @active_parent) %>'s description</p>


      <div class="max-w-3/4 m-auto flex flex-col justify-center items-center">
      <%= for position <- @positions do %>
        <%= if position.parent == @active_parent do %>
          <div
            class={"border border-secondary-500 m-2 max-w-3/4  w-72 text-center rounded-2xl"}
            >
            <h1 class="text-xl "> <%= position.title %> </h1>
            <section>
            <.icon name="hero-user-plus-solid" class="h-16 w-20 text-secondary-400"/>
            </section>
            <.link patch={~p"/organization?parent_id=#{position.id}"}>
              <.icon :if={has_children?(@positions, position.id)} name="hero-users-solid" class="h-8 w-8 text-primary-500" />
            </.link>
            <button phx-click={show_modal("position-description-#{position.id}")}>
              <.icon
              name = "hero-document-text-solid"
              class="h-8 w-8 text-primary-500"
              />
              </button>
              <.modal id={"position-description-#{position.id}"}>
                <div>
                  <p> Postion description for <%= position.title %> </p>
                  <p> <%= position.description %> </p>
                </div>
              </.modal>
          </div>
        <% end %>
      <% end %>
      </div>
      </div>
    """
  end

  def mount(_params=%{"parent_id" => parent_id}, _session, socket) do
    changeset = Organization.change_position(%Position{})
    active_parent = handle_parent(parent_id, Organization.list_positions())
    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, parents: get_parents_list(), positions: Organization.list_positions(), active_parent: active_parent)
      |> assign_form(changeset)

      FcClient.Mailer.welcome()

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def mount(_params, _session, socket) do
    changeset = Organization.change_position(%Position{})
    active_parent = 0
    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, parents: get_parents_list(), positions: Organization.list_positions(), active_parent: active_parent)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end


  def handle_params(_params=%{"parent_id" => parent_id}, _uri, socket) do

    {:noreply,
      socket
      |> assign(active_parent: handle_parent(parent_id, socket.assigns.positions))
    }
  end

  def handle_params(_params, _uri, socket) do

    {:noreply,
      socket
      |> assign(active_parent: 0)
    }
  end


  def handle_event("save", %{"position" => position_params}, socket) do
    position_params = Map.put_new(position_params, "parent", 0)
    case Organization.create_position(position_params) do
      {:ok, _position} ->
        changeset = Organization.change_position(%Position{})
        {:noreply,
          socket
          |> assign(trigger_submit: true,
                    parents: get_parents_list(),
                    positions: Organization.list_positions()
                    )
          |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"position" => position_params}, socket) do
    changeset = Organization.change_position(%Position{}, position_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("inc_parent", %{"parent" => parent}, socket) do
    {new_parent, _} =Integer.parse(parent)
    {:noreply,
      socket
      |>assign(active_parent: new_parent)
      |> push_patch(to: ~p"/organization?parent_id=#{new_parent}")
    }
  end

  def handle_event("dec_parent", _, socket) do
    new_parent =
      socket.assigns.positions
      |> Enum.filter(&(&1.id == socket.assigns.active_parent))
      |> List.first
    case socket.assigns.active_parent do
      0 ->
          {:noreply, socket}
      _ ->
        {:noreply,
         socket
          |> assign(active_parent: new_parent.parent)
          |> push_patch(to: ~p"/organization?parent_id=#{new_parent.parent}")
        }
    end
  end


  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "position")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp get_parents_list() do
    Organization.list_positions()
    |>Enum.map(&(["#{&1.title}": &1.id]))
    |>List.flatten()
    |>IO.inspect
  end

  defp breadcrumbs(assigns=%{parent: 0}) do
    ~H"""
      <p> No parents </p>
    """
  end

  defp breadcrumbs(assigns) do
    ~H"""
      <p> Your parent is <%= @parent %> </p>
    """
  end

  defp get_active_parent(_positions, 0), do: ""
  defp get_active_parent(positions, id) do
    position=
      positions
      |> Enum.filter( &(&1.id == id))
      |> List.first()

    position.title

  end

  defp get_parent_id(child_id, positions) do
    position =
      positions
        |> Enum.filter(&(&1.id == child_id))
        |> List.first()

    position.id
  end

  defp has_children?(positions, position_id) do
    positions
      |> Enum.any?(&(&1.parent == position_id))
  end

  defp handle_parent(id, positions) do
    {parsed_id, _} = Integer.parse(id)
    positions = Enum.map(positions, &(&1.id))

    case Enum.member?(positions, parsed_id) do
      true ->
          parsed_id
      _ ->
          0
    end

  end


end
