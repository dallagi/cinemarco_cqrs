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

  def reserve_seats(state, publish, screening_name, seats) do
    case state do
      %ScreeningState{name: nil} ->
        :error

      %ScreeningState{seats: screening_seats} ->
        if available?(state, seats) do
          publish.(%SeatsReserved{screening_name: screening_name, seats: seats})
          :ok
        else
          :error
      end
    end
  end

  defp available?(%ScreeningState{} = state, seats) do
    true
  end
end
