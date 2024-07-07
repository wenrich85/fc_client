defmodule FcClientWeb.BookingLive.Components do
  use FcClientWeb, :live_component

  attr :custodians, :list, required: true
  def employees(assigns) do
    ~H"""
       <!-- List of Janitors as Buttons -->
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <%= for custodian <- @custodians do %>
            <div>
            <button class="btn btn-primary bg-slate-500 rounded-3xl p-2 text-white font-bold" phx-click="show_schedule" value={custodian}>
            <.icon name="hero-user-circle" class="w-10 h-10 bg-white p-2" /> <%= custodian %>
            </button>
            </div>
            <% end %>
            <!-- Add more janitors here -->
        </div>
    """
  end

  attr :date, :any, required: true
  def calendar(assigns) do
    ~H"""

    <div class="grid grid-cols-9">
    <.previous_month_arrow />
    <div class="grid gap-1 grid-cols-7 col-span-7 max-w-xs bg-slate-200 border border-slate-600 p-2">

      <%= for d <- list_days() do %>
      <section class={ day_of_week_formatter() } > <%= d %> </section>
      <% end %>

      <%= for day <- get_days_of_month(@date) do %>
        <%= if day.day == 1 do %>
          <button phx-click="show_date" value={ day } class= { format_first_day(day) } > <%= day.day %> </button>
        <% else %>
        <button phx-click="show_date" value={ day }  class={ format_days(day)} > <%= day.day %> </button>
        <% end %>
      <% end %>
    </div>
    <.next_month_arrow />
    </div>
    """
  end
  def previous_month_arrow(assigns) do
    ~H"""
      <button class="rounded-full border-2 bg-white border-green-600 h-7 w-7 m-auto flex" phx-click="previous_month">
      <.icon name="hero-chevron-left-solid m-auto" class="w-10 h-5 bg-black-500 self-center" />
      </button>
    """
  end
  def next_month_arrow(assigns) do
    ~H"""
     <button class="bg-white rounded-full border-2 border-green-600 h-7 w-7 m-auto flex" phx-click="next_month">
      <.icon name="hero-chevron-right-solid m-auto" class="w-10 h-5 bg-black-500 self-center ml-1" />
      </button>
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
    case Timex.compare(day, Timex.beginning_of_day(NaiveDateTime.local_now())) do
      -1 -> "bg-slate-500 border border-black text-center"
      0 ->  "text-green-600 border border-black text-center " <> isToday?(day, NaiveDateTime.local_now())
      1 -> "text-green-700 bg-white border border-black text-center "
    end
  end
  defp format_first_day(day) do
    start = Timex.format!(day, "%A", :strftime) |> String.downcase()
    format_days(day)<>" #{start} "
  end
  defp list_days(), do: Enum.map(1..7, &(Timex.day_shortname(&1)|> String.at(0) ))
  defp isToday?(date, day) do
    case Timex.compare(Timex.beginning_of_day(date), Timex.beginning_of_day(day), :day) do
      0 -> "border-2 rounded-full border-green-500"
      _ -> ""
    end
  end


end
