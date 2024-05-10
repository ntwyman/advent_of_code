defmodule Day12 do
  defmodule Triplet do
    defstruct x: 0, y: 0, z: 0
  end

  defmodule Moon do
    defstruct pos: %Triplet{}, vel: %Triplet{}
  end

  @spec new_moon(String.t()) :: Moon.t()
  def new_moon(line) do
    [[x, y, z]] =
      Regex.scan(~r/<x=([-0-9]*), y=([-0-9]*), z=([-0-9]*)>/, line, capture: :all_but_first)

    %Moon{
      pos: %Triplet{x: String.to_integer(x), y: String.to_integer(y), z: String.to_integer(z)}
    }
  end

  @spec pairs([any()]) :: [{any(), any()}]
  def pairs(items) do
    case items do
      [_] ->
        []

      [one | rest] ->
        for(two <- rest, do: {one, two}) ++ pairs(rest)
    end
  end

  @spec gravity_delta(integer, integer) :: {integer, integer}
  def gravity_delta(pos_1, pos_2) do
    cond do
      pos_1 == pos_2 -> {0, 0}
      pos_1 > pos_2 -> {-1, 1}
      true -> {1, -1}
    end
  end

  @spec gravity(Moon.t(), Moon.t()) :: {Moon.t(), Moon.t()}
  def gravity(moon_1, moon_2) do
    {dvx1, dvx2} = gravity_delta(moon_1.pos.x, moon_2.pos.x)
    {dvy1, dvy2} = gravity_delta(moon_1.pos.y, moon_2.pos.y)
    {dvz1, dvz2} = gravity_delta(moon_1.pos.z, moon_2.pos.z)

    {%Moon{
       pos: moon_1.pos,
       vel: %Triplet{x: moon_1.vel.x + dvx1, y: moon_1.vel.y + dvy1, z: moon_1.vel.z + dvz1}
     },
     %Moon{
       pos: moon_2.pos,
       vel: %Triplet{x: moon_2.vel.x + dvx2, y: moon_2.vel.y + dvy2, z: moon_2.vel.z + dvz2}
     }}
  end

  @spec triplet_energy(Triplet.t()) :: integer
  def triplet_energy(triplet) do
    abs(triplet.x) + abs(triplet.y) + abs(triplet.z)
  end

  @spec total_energy(Moon.t()) :: integer
  def total_energy(moon) do
    triplet_energy(moon.pos) * triplet_energy(moon.vel)
  end

  @spec step(map()) :: map()
  def step(moons) do
    names = Map.keys(moons)

    delta_v_moons =
      Enum.reduce(pairs(names), moons, fn {name_1, name_2}, moon_state ->
        {new_1, new_2} = gravity(moon_state[name_1], moon_state[name_2])
        nm = Map.put(moon_state, name_1, new_1)
        Map.put(nm, name_2, new_2)
      end)

    Enum.reduce(names, delta_v_moons, fn name, moon_state ->
      moon = moon_state[name]

      Map.put(moon_state, name, %Moon{
        pos: %Triplet{
          x: moon.pos.x + moon.vel.x,
          y: moon.pos.y + moon.vel.y,
          z: moon.pos.z + moon.vel.z
        },
        vel: moon.vel
      })
    end)
  end

  @spec steps(map(), integer) :: map()
  def steps(moons, count) do
    Enum.reduce(1..count, moons, fn _, state -> step(state) end)
  end

  @spec system_energy(map()) :: integer
  def system_energy(moons) do
    Enum.sum(Enum.map(Map.values(moons), &total_energy/1))
  end

  def load_map(file_name) do
    Files.read_lines!(file_name)
    |> Enum.map(&new_moon/1)
    |> Enum.reduce({%{}, 0}, fn moon, {moon_map, index} ->
      {Map.put(moon_map, index, moon), index + 1}
    end)
    |> elem(0)
  end

  @spec part1(String.t()) :: integer
  def part1(file_name) do
    load_map(file_name)
    |> steps(1000)
    |> system_energy()
  end

  def count_steps(initial_state, moon_state, steps) do
    if rem(steps, 1_000_000) == 0, do: IO.write(".")

    if steps > 0 and moon_state == initial_state do
      steps
    else
      count_steps(initial_state, step(moon_state), steps + 1)
    end
  end

  def back_to_the_future(moon_state) do
    count_steps(moon_state, moon_state, 0)
  end

  @spec part2(String.t()) :: integer
  def part2(file_name) do
    load_map(file_name)
    |> back_to_the_future()
  end
end
