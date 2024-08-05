defmodule FcClientWeb.BookingLive do
  import FcClientWeb.BookingLive.Components
  use FcClientWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
    socket
      |> assign(:custodians, Enum.map(FcClient.Accounts.get_all_users, &(&1.name)))
      |> assign(:page_title, "Booking")
      |> assign(:custodian, nil)
      |> assign(:date, NaiveDateTime.local_now())
    }
  end

  def handle_params(unsigned_params, _uri, socket) do
    {:noreply, maybe_start_schedule(unsigned_params["name"], socket)}
  end

  def render(assigns) do
    ~H"""

     <div class="container mx-auto bg-white p-6 rounded-lg shadow-lg">
        <h1 class="text-xl font-semibold mb-4">Janitor List</h1>

        <.employees custodians={@custodians} />
    </div>
    <%= if assigns.custodian do %>
      <div class="container mx-auto bg-white p-6 rounded-lg shadow-lg mt-2">
        <h1 class="text-xl font-semibold mb-4">Daily Calendar</h1>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div class="md:col-span-1">
                <!-- Sidebar or Mini-Calendar -->
                <div class="bg-gray-100 p-4 rounded-lg">
                    <h2 class="text-lg font-semibold text-center"><%= month_year(@date) %></h2>
                    <.calendar date={ @date } />
                        <%= if Bookme.schedule_created?(assigns.custodian, ~N[2023-11-12 08:00:00.000] ) do %>
                        <div class="grid grid-cols-3">
                        <%= for time <- Bookme.show_appointment_times("Felicia", %{start_time: ~N[2023-11-12 08:00:00.000], duration: 120}) do %>
                          <a href="#"> <p class="bg-indigo-600 font-bold p-2 m-2 rounded-lg text-white text-center"> <%= format_time(time.from) %> </p> </a>
                        <% end %>
                        </div>
                        <% end %>
                </div>
            </div>
            <div class="md:col-span-2">
                <!-- Calendar Header -->
                <div class="mb-4">
                <button class="bg-indigo-600 p-2 rounded font-bold text-white" phx-click="start_calendar">Start <%= assigns.custodian %>'s Calendar</button>
                    <div class="flex justify-between items-center">
                        <h2 class="text-lg font-semibold">Date: <%= format_date(@date) %></h2>
                        <button class="btn btn-primary bg-amber-500 p-2 rounded font-bold text-white">Add Appointment</button>
                    </div>
                </div>


                <!-- Calendar Events -->
                <div class="space-y-4">
                    <div class="bg-blue-100 p-4 rounded-lg">
                        <h3 class="text-lg font-semibold">Event 1</h3>
                        <p>10:00 AM - 11:30 AM</p>
                        <p>Description: Lorem ipsum dolor sit amet.</p>
                    </div>
                    <div class="bg-yellow-100 p-4 rounded-lg">
                        <h3 class="text-lg font-semibold">Event 2</h3>
                        <p>2:00 PM - 3:30 PM</p>
                        <p>Description: Consectetur adipiscing elit.</p>
                    </div>
                    <!-- Add more events here -->
                </div>
            </div>

        </div>
    </div>
    <% end %>
    """
  end

  def handle_event("show_calendar", _value, socket) do
    Bookme.start_schedule("Felicia")
    schedule = Bookme.add_schedule("Felicia", %{start_time: ~N[2023-11-12 07:00:00.000], end_time: ~N[2023-11-12 19:00:00.000], duration: 12, date: ~N[2023-11-12 00:00:00.000]})
    {:noreply, assign(socket, :schedule, schedule)}
  end

  def handle_event("show_date", %{"value" => date} = _value, socket) do
    {:ok, date} = Timex.parse(date, "{ISO:Extended}")
    {:noreply,
    socket
    |> assign(:date, date)
    }
  end

  def handle_event("start_custodian", value, socket) do
    IO.inspect(value)
    {:noreply,
    socket
  }
  end

  def handle_event("show_schedule", %{"value" => name}, socket) do
    {:noreply,
    socket
    |> push_patch( to: ~p"/booking/?name=#{create_name_params(name)}")

  }
  end

  def handle_event("previous_month", _value, socket) do
    {:noreply,
    socket
    |> assign(date: get_previous_month(socket.assigns.date))
    }
  end
  def handle_event("next_month", _value, socket) do
    {:noreply,
    socket
    |> assign(date: get_next_month(socket.assigns.date))
    }
  end

  defp format_time(date) do
    Timex.format!(date, "%H:%M", :strftime)
  end

  defp format_date(date), do: Timex.format!(date, "%B %-d, %Y", :strftime)
  defp maybe_start_schedule(nil, socket), do: socket
  defp maybe_start_schedule(name, socket) do
    name = parse_name_params(name)
    Bookme.start_schedule(name)
    socket
    |> assign(:custodian, name)
  end

  defp parse_name_params(name) do
    name
    |> String.downcase()
    |> String.replace("_", " ")
    |> String.split()
    |> Enum.map(&(String.capitalize(&1)))
    |> Enum.join(" ")
  end

  defp create_name_params(name) do
    name
    |> String.downcase()
    |> String.replace(" ", "_")
  end
  defp get_previous_month(date) do
    date
    |> Timex.beginning_of_month()
    |> Timex.subtract(Timex.Duration.from_days(1))
    |> Timex.beginning_of_month()
  end
  defp get_next_month(date) do
    date
    |> Timex.end_of_month()
    |> Timex.add(Timex.Duration.from_days(1))
  end
  defp month_year(date), do: Timex.format!(date, "%B %Y", :strftime)

end
