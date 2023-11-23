defmodule FcClientWeb.BookingLive.Components do
  use FcClientWeb, :live_component

  attr :custodians, :list, required: true
  def employees(assigns) do
    ~H"""
       <!-- List of Janitors as Buttons -->
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <%= for custodian <- assigns.custodians do %>
            <button class="btn btn-primary" phx-click="show_schedule" value={custodian}><%= custodian %></button>
            <% end %>
            <!-- Add more janitors here -->
        </div>
    """
  end

  def calendar(assigns) do
    ~H"""

    <div class="grid gap-1 grid-cols-7 max-w-xs border border-slate-600 p-2">

      <%= for d <- list_days() do %>
      <section class={ day_of_week_formatter() } > <%= d %> </section>
      <% end %>

      <%= for day <- get_days_of_month(NaiveDateTime.local_now()) do %>
        <%= if day.day == 1 do %>
          <button phx-click="show_date" value={ day } class= { format_first_day(day) } > <%= day.day %> </button>
        <% else %>
        <button phx-click="show_date" value={ day }  class={ format_days(day)} > <%= day.day %> </button>
        <% end %>
      <% end %>
    </div>

    """
  end

  def render(assigns) do
    ~H"""
    """
  end

  def get_days_of_month(date) do
    Enum.map(1..Timex.days_in_month(date),
      &(
        Timex.beginning_of_month(date)
        |> Timex.subtract(Timex.Duration.from_days(1))
        |> Timex.add(Timex.Duration.from_days(&1))
      )
    )
    |> Enum.sort()
  end
  defp day_of_week_formatter() do
    "bg-black text-white text-bold text-center"
  end
  defp format_days(day) do
    case day < Timex.beginning_of_day(NaiveDateTime.local_now()) do
      true -> "bg-slate-500 border border-black text-center"
      _ ->  "text-green-500 border border-black text-center " <> isToday?(day, NaiveDateTime.local_now())
    end
  end
  defp format_first_day(day) do
    start = Timex.format!(day, "%A", :strftime) |> String.downcase()
    format_days(day)<>" #{start} "
  end
  defp list_days(), do: Enum.map(1..7, &(Timex.day_shortname(&1)|> String.at(0) ))
  defp isToday?(date, day) do
    case Timex.compare(Timex.beginning_of_day(date), Timex.beginning_of_day(day), :day) do
      0 -> "border-2 border-red-500"
      _ -> ""
    end
  end


end
