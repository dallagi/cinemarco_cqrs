alias CinemarcoCqrs.ScreeningState
alias CinemarcoCqrs.Events.{ScreeningCreated, SeatsReserved}

defmodule CinemarcoCqrs.Screening do
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

  def reserve_seats(%ScreeningState{seats: screening_seats}, publish, screening_name, seats) do
    if available?(screening_seats, seats) do
      publish.(%SeatsReserved{screening_name: screening_name, seats: seats})
      :ok
    else
      :error
    end
  end

  defp available?(screening_seats, seats) do
    Enum.all?(seats, &Map.get(screening_seats, &1, false))
  end
end
