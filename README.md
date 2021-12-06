# Reverse Match 
But we do have `=`, why need this one?

Let's see some snips:

```elixir
  init_fun = fn -> %{a: 1, b: 2} end
  update_fun = fn current -> {current.a, %{current| a: curent.a + 1}} end
  {:ok,pid} = Agent.start_link(init_fun)
  value_of_a = Agent.get_and_update(pid, update_fun)
```
and
```elixir
  value_of_a =
  Agent.start_link(init_fun)
  |> &(Agent.get_and_update(elem(&1,1), update_fun))
```

They are neither clear than I hope.

With help of `ReverseMatch.tr/2`, I can write like this:

```
import ReverseMatch
Agent.start_link(init_fun)
|> tr to: {:ok, pid}, do: pid
|> Agent.get_and_update(update_fun)
|> tr to: value_of_a, do: do_more
```