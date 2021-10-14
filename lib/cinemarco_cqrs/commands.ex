defmodule CinemarcoCqrs.Commands do
  use TypedStruct

  typedstruct module: CreateScreening do
    field :name, String.t()
    field :seats, [pos_integer()]
  end
end
