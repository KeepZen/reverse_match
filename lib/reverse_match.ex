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
  For me, the flow is broken.

  In the pipeline flow, if the function do not return the match value,
  the flow will be broken.
  With the help of `tr`, we can transform the the flowed value to
  what the next function required.
  ```
  import ReverseMatch
  defp server(socket) do
    socket
    |> read_line()
    |> write_line(socket)
    |> tr(to: _, do: socket)
    |> server
  end
  ```
  """

  @doc """
  transform value to `new_form` or do `more`.

  `opts` required have a `:to`.

  `to: new_form` use to transform to `new_form`,
  after the `:to` we can add a `do: more` to do more thing.

  ## Example of  `tr(value, to: new_form)`
  `tr` transform the `value` to new `new_form`,
  return  `value`, and the variables in
  the `new_form` are binded.
  ```
      import ReverseMatch
      tr({a: 1, b: 2}, to: {a: a, b: _})
      a #=> 1
  ```

  ## Example of tr(value, to: new_form, do: more)
  After binded variables in `new_form`, do `more` work use the varaibles.
  The return is the value of `more`.
  ```
  import ReverseMatch
  Agent.start_link(fn ->10 end))
  |> tr(to: {:ok,pid}, do: pid) # now pid flow downside.
  |> Agent.get(&(&1))

  # pid is a varibale, after the pipeline, we can stil use it.
  Agent.stop(pid)
  ```
  """
  @spec tr(value :: term, opts :: keyword) :: term
  defmacro tr(value, opts)

  defmacro tr(value, to: new_form) do
    quote do
      unquote(new_form) = unquote(value)
    end
  end

  defmacro tr(value, to: new_form, do: more) do
    quote do
      unquote(new_form) = unquote(value)
      unquote(more)
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
