defmodule Forth do
  @type t :: %Forth{env: Map.t(), stack: List.t()}
  defstruct env: %{}, stack: []

  @opaque evaluator :: Forth.t()
  @operators ["dup", "drop", "swap", "over", "+", "-", "*", "/"]

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new(), do: %Forth{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> tokenize(ev.env)
    |> eval_tokens(ev)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev.stack
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  defp tokenize(input, env) do
    input
    |> String.split(~r/[^\w\d\p{S}\p{P}]+/u)
    |> tokens(env)
  end

  defp tokens([], _), do: []

  defp tokens([h | t], env) do
    cond do
      h == ":" ->
        {d, rest} = word_definition(tl(t), [])
        [{:define, hd(t), d} | tokens(rest, env)]

      Map.has_key?(env, h) ->
        [{:word, h} | tokens(t, env)]

      true ->
        [token(h) | tokens(t, env)]
    end
  end

  defp token(word) do
    cond do
      String.downcase(word) in @operators -> {:operator, String.downcase(word)}
      number?(word) -> {:integer, String.to_integer(word)}
      true -> {:word, word}
    end
  end

  defp word_definition([";" | t], res), do: {res, t}

  defp word_definition([h | t], res) do
    word_definition(t, [token(h) | res])
  end

  defp number?(string) do
    String.match?(string, ~r/^\d+$/)
  end

  defp eval_tokens([], ev), do: ev

  defp eval_tokens([{:integer, num} | t], ev) do
    eval_tokens(t, %{ev | :stack => [num | ev.stack]})
  end

  defp eval_tokens([{:operator, op} | t], ev) do
    eval_tokens(t, execute(op, ev))
  end

  defp eval_tokens([{:define, w, d} | t], ev) do
    if number?(w) do
      raise Forth.InvalidWord
    else
      eval_tokens(t, %{ev | :env => Map.put(ev.env, w, d)})
    end
  end

  defp eval_tokens([{:word, w} | t], ev) do
    if not Map.has_key?(ev.env, w) do
      raise Forth.UnknownWord
    else
      eval_tokens(ev.env[w] ++ t, ev)
    end
  end

  defp add([a, b | t]), do: [a + b | t]
  defp add(_), do: raise(Forth.StackUnderflow)

  defp sub([a, b | t]), do: [b - a | t]
  defp sub(_), do: raise(Forth.StackUnderflow)

  defp mul([a, b | t]), do: [a * b | t]
  defp mul(_), do: raise(Forth.StackUnderflow)

  defp div([0, _ | _]), do: raise(Forth.DivisionByZero)
  defp div([a, b | t]), do: [div(b, a) | t]
  defp div(_), do: raise(Forth.StackUnderflow)

  defp dup([a | t]), do: [a, a | t]
  defp dup(_), do: raise(Forth.StackUnderflow)

  defp drop([_a | t]), do: t
  defp drop(_), do: raise(Forth.StackUnderflow)

  defp over([a, b | t]), do: [b, a, b | t]
  defp over(_), do: raise(Forth.StackUnderflow)

  defp swap([a, b | t]), do: [b, a | t]
  defp swap(_), do: raise(Forth.StackUnderflow)

  defp execute(op, ev) do
    case op do
      "+" -> %{ev | :stack => add(ev.stack)}
      "-" -> %{ev | :stack => sub(ev.stack)}
      "*" -> %{ev | :stack => mul(ev.stack)}
      "/" -> %{ev | :stack => div(ev.stack)}
      "dup" -> %{ev | :stack => dup(ev.stack)}
      "drop" -> %{ev | :stack => drop(ev.stack)}
      "over" -> %{ev | :stack => over(ev.stack)}
      "swap" -> %{ev | :stack => swap(ev.stack)}
    end
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
