defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekdays %{
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  @day_ranges %{
    first: 1..7,
    second: 8..14,
    third: 15..21,
    fourth: 22..28,
    teenth: 13..19,
    last: 31..21
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    wday =
      Enum.find(
        @day_ranges[schedule],
        &day_at?(weekday, {year, month, &1})
      )

    {:ok, date} = Date.new(year, month, wday)
    date
  end

  defp day_at?(weekday, date) do
    :calendar.valid_date(date) &&
      :calendar.day_of_the_week(date) == @weekdays[weekday]
  end
end
