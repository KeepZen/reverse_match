defmodule ReverseMatch do
  @moduledoc """
  Suport reverse match to help write more clear code.

  But we do have `=`, why need a reverse one?
  Let's see some snips:

  ```elixir
  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end
  ```
  This is snipe from the [Task and gen_tcp](https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html).
  Why the last line do not use `|>`? Because `write_line/2` do not
  return socket, and `serve/1` want it.
  The pipele is broken.

  In the pipeline, if the upstream function return value is not the
  downstream function's first required, the pipeline will be broken.
  With the help of `tr`, we can transform the value from the upstream to
  what the next function required, like this:
  ```
  import ReverseMatch
  defp server(socket) do
    socket
    |> read_line()
    |> write_line(socket)
    |> tr(_, do: socket)
    |> server
  end
  ```
  """

  @doc """
  Transform the `value` to `new_form`.

  Just as `tr(value, new_form)` same as `new_form = value`.
  ## Examples tr(value,new_from)
  ```
  iex>import ReverseMatch
  iex>ab = [a: 1, b: 2]
  iex>tr(ab, [a: a, b: _])
  iex>a
  1
  ```

  After binding variables in `new_form`, we can do more wrok in the `do_block`,
  and the the variables in the `new_from` at the same scope as this `do_block`.

  ## Examples tr(value,new_form, do: more)
  ```
  iex>import ReverseMatch
  iex>Agent.start_link(fn ->10 end) |>
  iex> tr({:ok,pid}, do: pid) |>
  iex> Agent.get(&(&1))
  10
  iex>Agent.stop(pid)
  :ok
  ```
  ## Returns
  If there is `do_more` block, the value of the `do_more` will return,
  else the `vlaue` return.
  """
  defmacro tr(value, new_form, do_more \\ nil) do
    match_ast =
      quote do
        unquote(new_form) = unquote(value)
      end

    if do_more != nil do
      quote do
        unquote(match_ast)
        unquote(do_more[:do])
      end
    else
      match_ast
    end
  end

  @doc """
  Return a zero argument function, it always return the `value`.

  ## Examples
  ```
  iex>import ReverseMatch
  iex>{:ok,pid} = Agent.start_link(const(10))
  iex>Agent.get(pid,&(&1))
  10
  ```
  """
  def const(value), do: fn -> value end

  @doc """
  Just short the name of `Function.identity/1`
  ## Examples
  ```
  iex>import ReverseMatch
  iex>id(1)
  1
  ```
  """
  defdelegate(id(value), to: Function, as: :identity)
end
