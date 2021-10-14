defmodule CinemarcoCqrs.Events do
  use TypedStruct

  typedstruct module: ScreeningCreated do
    field :name, String.t()
    field :seats, [pos_integer()]
    field :starts_at, DateTime.t()
  end

  typedstruct module: SeatsReserved do
    field :screening_name, String.t()
    field :seats, [pos_integer()]
  end
end
