alias CinemarcoCqrs.ScreeningState
alias CinemarcoCqrs.Events.ScreeningCreated

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
end
