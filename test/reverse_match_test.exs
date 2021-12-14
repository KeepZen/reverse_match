defmodule ReverseMatchTest do
  use ExUnit.Case
  doctest ReverseMatch

  import ReverseMatch

  test "macro tr(value, to: pattern)" do
    %{a: 1}
    |> Map.get_and_update(:a, &{&1, &1 + 1})
    |> tr({a, map})

    assert 1 = a
    assert %{a: 2} = map
  end

  test "macro tr(value,pattern, do: block)" do
    %{a: 1}
    |> Map.get_and_update(:a, &{&1, &1 + 1})
    |> tr {_, map} do
      map = Map.merge(map, %{b: "new field"})
    end

    assert %{a: 2, b: "new field"} = map
  end

  test "macro tr(value,form, do-block)" do
    Agent.start_link(fn -> 10 end)
    |> tr({:ok, pid}, do: pid)
    |> Agent.get(& &1)
    |> tr(result)

    Agent.stop(pid)
    assert result == 10

    1
    |> tr a do
      a + 2
    end
    |> tr(b)

    assert a == 1
    assert b == 3
  end
end
