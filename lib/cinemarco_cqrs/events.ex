defmodule CinemarcoCqrs.Events do
  use TypedStruct

  typedstruct module: ScreeningCreated do
    field :name, String.t()
    field :seats, [pos_integer()]
  end
end
