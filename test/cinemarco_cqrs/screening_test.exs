defmodule CinemarcoCqrs.ScreeningTest do
  use ExUnit.Case, async: true

  alias CinemarcoCqrs.CommandHandler
  alias CinemarcoCqrs.Commands.{CreateScreening, ReserveSeats}
  alias CinemarcoCqrs.Events.{ScreeningCreated, SeatsReserved}

  test "creates screening" do
    given([])
    |> whenever(%CreateScreening{
      name: "Titanic",
      seats: [1, 2, 3],
      starts_at: minutes_from_now(60)
    })
    |> then_expect([%ScreeningCreated{name: "Titanic", seats: [1, 2, 3]}])
  end

  test "cannot reserve seats if screening does not exist" do
    given([])
    |> whenever(%ReserveSeats{screening_name: "Titanic", seats: [1]})
    |> then_expect([])
  end

  test "can reserve seats when they are available" do
    given([%ScreeningCreated{name: "Titanic", seats: [1, 2, 3], starts_at: minutes_from_now(60)}])
    |> whenever(%ReserveSeats{screening_name: "Titanic", seats: [1]})
    |> then_expect([%SeatsReserved{screening_name: "Titanic", seats: [1]}])
  end

  test "cannot reserve seats when they have already been reserved" do
    given([
      %ScreeningCreated{name: "Titanic", seats: [1, 2, 3], starts_at: minutes_from_now(60)},
      %SeatsReserved{screening_name: "Titanic", seats: [1]}
    ])
    |> whenever(%ReserveSeats{screening_name: "Titanic", seats: [1]})
    |> then_expect([])
  end

  test "cannot reserve tickets after 15 mins before screening starts" do
    given([%ScreeningCreated{name: "Titanic", seats: [1, 2, 3], starts_at: minutes_from_now(5)}])
    |> whenever(%ReserveSeats{screening_name: "Titanic", seats: [1]})
    |> then_expect([])
  end

  defp given(events), do: events

  defp whenever(history, command) do
    CommandHandler.handle(history, fn event -> send(self(), {:event, event}) end, command)
    :ok
  end

  defp then_expect(:ok, expected_events) do
    for expected_event <- expected_events do
      receive do
        {:event, event} -> assert event == expected_event
      after
        0 -> flunk("Event #{inspect(expected_event)} was not published")
      end
    end

    receive do
      {:event, event} -> flunk("Received unexpected event #{inspect(event)}")
    after
      0 -> nil
    end
  end

  defp minutes_from_now(amount), do: DateTime.add(DateTime.utc_now(), amount * 60, :second)
end
