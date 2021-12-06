defmodule ReverseMatch do
  @moduledoc """
  Suport reverse match to help to write more clear code.

  Read [more](https://github.com/KeepZen/reverse_match).
  """

  @doc """
  transefome value to `new_form` or do `more`

  ## Example of  `tr(value, to: form)`
  `tr` transform the `value` to new `new_form`,
  we the value of `value`, and the variables in
  the `new_form` binded.
  ```
      import ReverseMatch
      tr({a: 1, b: 2}, to: {a: a, b: _})
      a #=> 1
  ```

  ## Example of tr(value, to: new_form, do: more)
  After binded variables in `new_form`, do `more` work use the varaibles.
  The value is the value of `more`
  ```
  import ReverseMatch
  Agent.start_link(fn ->10 end))
  |> tr(to: {:ok,pid}, do: pid) # now pid flow downside.
  |> Agent.get(&(&1))

  # pid is a varibale, after the pipeline, we can stil use it.
  Agent.stop(pid)
  ```
  """
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
end
