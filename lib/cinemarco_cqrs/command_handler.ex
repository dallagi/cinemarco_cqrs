alias CinemarcoCqrs.Commands.CreateScreening
alias CinemarcoCqrs.{Screening, ScreeningState}

defmodule CinemarcoCqrs.CommandHandler do
  def handle(history, publish, %CreateScreening{name: name, seats: seats}) do
    state = ScreeningState.new(history)
    Screening.create_screening(state, publish, name, seats)
  end
end
