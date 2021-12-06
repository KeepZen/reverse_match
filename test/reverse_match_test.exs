defmodule ReverseMatchTest do
  use ExUnit.Case
  doctest ReverseMatch

  import ReverseMatch

  test "macro tr(value, to: pattern)" do
    %{a: 1}
    |> Map.get_and_update(:a, &{&1, &1 + 1})
    |> tr(to: {a, map})

    assert 1 = a
    assert %{a: 2} = map
  end

  test "macro tr(value,to: pattern, do: block)" do
    %{a: 1}
    |> Map.get_and_update(:a, &{&1, &1 + 1})
    |> tr(to: {_, map}, do: map = Map.merge(map, %{b: "new filed"}))

    assert %{a: 2, b: _} = map

    Agent.start_link(fn -> 10 end)
    |> tr(to: {:ok, pid}, do: pid)
    |> Agent.get(& &1)
    |> tr(to: result)

    Agent.stop(pid)
    assert result == 10
  end
end
