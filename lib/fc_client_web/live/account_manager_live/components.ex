defmodule FcClientWeb.AccountManagerLive.Components do
  #alias FcClient.Accounts
  use FcClientWeb, :live_component

  def render(assigns) do
    ~H"""
    """
  end

  def tabs_panel(assigns) do
    ~H"""
      <div class="bg-gray-800 rounded-xl text-white h-full p-4">
        <h1 class="text-2xl font-semibold mb-4">Account Manager</h1>

        <!-- Tabs -->
        <div class="space-y-2">
            <.tab name={"All Users"} tab_action={"all"}/>
            <.tab name={"Customers"} tab_action={"user"}/>
            <.tab name={"Employees"} tab_action={"employee"}/>
            <.tab name={"Adminstrators"} tab_action={"admin"}/>
            <.tab name={"Managers"} tab_action={"manager"}/>
        </div>
      </div>
    """
  end

  attr :tab_action, :string, required: true
  attr :name, :string, required: true
  def tab(assigns) do
    ~H"""
    <button phx-click="tab_selected"
    phx-value-role={@tab_action}class="cursor-pointer block py-2 px-4 transition duration-300 ease-in-out transform hover:bg-gray-700"><%= @name %>
    </button>
    """
  end

  attr :users, :list, required: true
  attr :roles, :list, required: true
  attr :form, :map, required: true

  def user_administration(assigns=%{roles: []}) do
    ~H"""
      <div class="p-4">
        <div class="tab-content" id="tab1-content">
            <!-- slot Content -->
            <h1> Welcome to the the account managment page </h1>
            <h2> Select a tab on the left to proceed. </h2>
        </div>
      </div>
    """
  end
  def user_administration(assigns=%{roles: []}) do
    ~H"""
      <div class="p-4">
        <div class="tab-content" id="tab1-content">
            <!-- Customers Tab Content -->
            <p>Select a tab mf </p>
        </div>
      </div>
    """
  end
  def user_administration(assigns=%{roles: [:admin]}) do
    ~H"""
      <div class="p-4">
        <div class="tab-content" id="tab1-content">
            <!-- Customers Tab Content -->

        <.button id="createEmployeeBtn" class="btn btn-primary mb-4">Create New Employee</.button>
            <div class="flex">
            <%= for user <- Enum.filter(@users, &(&1.role in @roles)) do %>
              <.employee_card user={user} />
            <% end %>
            </div>
        </div>
      </div>
    """
  end
  def user_administration(assigns=%{roles: [:employee, :owner]}) do
    ~H"""
      <div class="p-4">
        <div class="tab-content" id="tab1-content">

        <button id="createEmployeeBtn" class="btn btn-primary mb-4">Create New Employee</button>
            <!-- Customers Tab Content -->
            <.modal id="employee">
              <p> Test </p>
            </.modal>
            <button phx-click={show_modal("employee")}> Show </button>
            <p>Employee content goes here.</p>
            <%= for user <- Enum.filter(@users, &(&1.role in @roles)) do %>
              <p> <%= user.name %> </p>
              <% end %>
        </div>
      </div>
    """
  end
  def user_administration(assigns=%{roles: [:user]}) do
    ~H"""
      <div class="p-4">
        <div class="tab-content" id="tab1-content">
            <!-- Customers Tab Content -->
            <p>Customers content goes here.</p>
            <%= for user <- Enum.filter(@users, &(&1.role in @roles)) do %>
              <.user_card user={user} />
              <% end %>
        </div>
      </div>
    """
  end
  def user_administration(assigns=%{roles: [:manager]}) do
    ~H"""
      <div class="p-4">
        <div class="tab-content" id="tab1-content">
            <!-- Manager Tab Content -->
            <p>Manager content goes here.</p>
            <%= for user <- Enum.filter(@users, &(&1.role in @roles)) do %>
              <.employee_card user={user} />
              <% end %>
        </div>
      </div>
    """
  end
  # Tab for all users
  def user_administration(assigns=%{roles: [:user, :admin, :employee, :manager]}) do
    ~H"""
      <div class="p-4">
        <div class="tab-content" id="tab1-content">
            <!-- All users Tab Content -->
            <%= for user <- Enum.filter(@users, &(&1.role in @roles)) do %>
            <div class="flex items-center">
              <p> <%= user.name %> </p> <p> <.user_update_form user={user} form={@form}/></p>
            </div>
              <% end %>
        </div>
      </div>
    """
  end

  attr :user, :map, required: true
  attr :form, :map, required: true
  def user_update_form(assigns) do
    ~H"""
      <.form for={@form} phx-value-user_id={@user.email} phx-submit="save">
      <section class="flex items-center ">
        <.input field={@form[:role]} type="select" prompt={"Select a new role"} options={[[key: :Administrator, value: :admin],
              [key: :Customer, value: :default],
              [key: :Employee, value: :employee],
              [key: :Manager, value: :manager]]} />
          <button class="m-4 p-1 rounded-xl bg-green-600"> save </button>
          </section>
      </.form>
    """
  end
  attr :user, :map, required: true
  def user_card(assigns) do
    ~H"""
      <div class="w-1/4 rounded-xl p-5 m-2 bg-white">
      <a href="#">
        <p> <strong>Name:</strong> <%= @user.name %> </p>
        <p> <strong>Email:</strong> <%= @user.email %> </p>
      </a>
      </div>
    """
  end

  attr :user, :map, required: true
  def employee_card(assigns) do
    ~H"""
      <div class="w-1/3 rounded-xl p-5 m-2 bg-white">
      <div>
        <p class={[
          Bookme.find_booking_server(@user.name) == true && "glowing-circle mb-5",
          Bookme.find_booking_server(@user.name) == false && "red-circle mb-5"]} />
        <h2 class="text-lg font-semibold mb-2"><%= @user.name %></h2>
          <p class="text-gray-600">ID: <%= @user.id %></p>
          <p class="text-gray-600">E-Mail: <%= @user.email %></p>
          <div class="mt-2">
            <.button class="btn btn-primary mr-2">Edit</.button>
            <.button class="btn btn-danger mr-2">Delete</.button>
            <.button class="btn btn-secondary" phx-click={show_modal("employee-#{@user.id}")} >View Details</.button>
          </div>
      </div>
      <.modal id={"employee-#{@user.id}"}>
        <p> <%= @user.name %> </p>
        <.button> Set Schedule </.button>
      </.modal>
      </div>
    """
  end

  def circle(assigns) do
    ~H"""
      <div class="container mx-auto bg-white p-6 rounded-lg shadow-lg">
        <h1 class="text-xl font-semibold mb-4">Green Glowing Circle</h1>

        <!-- Green Glowing Circle -->

    </div>
    """
  end

  def schedule_form(assigns) do
    ~H"""
      <%!-- <.simple_form></.simple_form> --%>
    """
  end
end
