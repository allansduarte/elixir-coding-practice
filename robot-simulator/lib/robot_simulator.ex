defmodule RobotSimulator do
  @right %{:north => :east, :east => :south, :south => :west, :west => :north}
  @left %{:north => :west, :west => :south, :south => :east, :east => :north}
  @adv %{:north => {0, 1}, :east => {1, 0}, :south => {0, -1}, :west => {-1, 0}}

  defstruct position: {0, 0}, direction: :north

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any

  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _position) when not (direction in [:north, :east, :south, :west]) do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y}) when is_integer(x) and is_integer(y) do
    %RobotSimulator{direction: direction, position: {x, y}}
  end

  def create(_direction, _position) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.to_charlist()
    |> Enum.reduce_while(robot, fn
      ?R, robot ->
        {:cont, %{robot | direction: Map.fetch!(@right, robot.direction)}}

      ?L, robot ->
        {:cont, %{robot | direction: Map.fetch!(@left, robot.direction)}}

      ?A, robot ->
        {ox, oy} = robot.position
        {dx, dy} = Map.fetch!(@adv, robot.direction)
        {:cont, %{robot | position: {ox + dx, oy + dy}}}

      _invalid, _robot ->
        {:halt, {:error, "invalid instruction"}}
    end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot), do: robot.position
end
