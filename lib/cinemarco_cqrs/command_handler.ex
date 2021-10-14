alias CinemarcoCqrs.Commands.{CreateScreening, ReserveSeats}
alias CinemarcoCqrs.{Screening, ScreeningState}

defmodule CinemarcoCqrs.CommandHandler do
  def handle(history, publish, %CreateScreening{name: name, seats: seats}) do
    state = ScreeningState.new(history)
    Screening.create_screening(state, publish, name, seats)
  end

  def handle(history, publish, %ReserveSeats{screening_name: screening_name, seats: seats}) do
    state = ScreeningState.new(history)
    Screening.reserve_seats(state, publish, screening_name, seats)
  end
end
