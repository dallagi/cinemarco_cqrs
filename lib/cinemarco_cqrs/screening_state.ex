alias CinemarcoCqrs.Events.{ScreeningCreated, SeatsReserved}

defmodule CinemarcoCqrs.ScreeningState do
  use TypedStruct

  typedstruct do
    field(:name, String.t())
    field(:seats, %{pos_integer() => available? :: boolean()})
  end

  def new(history) do
    Enum.reduce(
      history,
      %__MODULE__{},
      fn event, state -> __MODULE__.apply(state, event) end
    )
  end

  def apply(%__MODULE__{}, %ScreeningCreated{name: name, seats: seats}) do
    seats =
      seats
      |> Enum.map(fn seat -> {seat, true} end)
      |> Enum.into(%{})

    %__MODULE__{name: name, seats: seats}
  end

  def apply(%__MODULE__{} = state, %SeatsReserved{seats: reserved_seats}) do
    reservations = reserved_seats
    |> Enum.map(&{&1, false})
    |> Enum.into(%{})

    %__MODULE__{state | seats: Map.merge(state.seats, reservations)}
  end
end
