defmodule CinemarcoCqrs.Screening do
  alias CinemarcoCqrs.ScreeningState
  alias CinemarcoCqrs.Events.{ScreeningCreated, SeatsReserved}

  @time_threshold_minutes 15

  def create_screening(state, publish, name, seats) do
    case state do
      %ScreeningState{name: nil} ->
        publish.(%ScreeningCreated{name: name, seats: seats})
        :ok

      _ ->
        :error
    end
  end

  def reserve_seats(%ScreeningState{name: nil}, _, _, _), do: :error

  def reserve_seats(
        %ScreeningState{seats: screening_seats, starts_at: start_time},
        publish,
        screening_name,
        seats
      ) do
    if available?(screening_seats, seats) and in_time?(start_time) do
      publish.(%SeatsReserved{screening_name: screening_name, seats: seats})
      :ok
    else
      :error
    end
  end

  defp available?(screening_seats, seats) do
    Enum.all?(seats, &Map.get(screening_seats, &1, false))
  end

  defp in_time?(start_time) do
    seconds_before_screening = DateTime.diff(start_time, DateTime.utc_now())
    seconds_before_screening > @time_threshold_minutes * 60
  end
end
