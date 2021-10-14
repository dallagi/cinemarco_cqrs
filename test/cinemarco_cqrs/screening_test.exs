defmodule CinemarcoCqrs.ScreeningTest do
  use ExUnit.Case, async: true

  alias CinemarcoCqrs.{CommandHandler, Commands, EventStore, Events, Screening}

  test "creates screening" do
    given([])
    |> whenever(%Commands.CreateScreening{name: "Titanic", seats: [1, 2, 3]})
    |> then_expect([%Events.ScreeningCreated{name: "Titanic", seats: [1, 2, 3]}])
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
      after 0 -> flunk("Event #{inspect(expected_event)} was not published")
      end
    end
  end
end
