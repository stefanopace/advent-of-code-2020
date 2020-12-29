defmodule Day12 do
	@doc """
	## Examples
		iex> Input.read(12) |> Day12.part1
		1152
	"""
	def part1(input) do
		input
		|> decode_instructions
		|> navigate({90, {0, 0}})
		|> manhattan_distance
	end

	@doc """
	## Examples
		iex> Input.read(12) |> Day12.part2
		58637
	"""
	def part2(input) do
		input
		|> decode_instructions
		|> navigate_waypoint({{10, 1}, {0, 0}})
		|> manhattan_distance
	end

	defp manhattan_distance({x, y}) do
		abs(x) + abs(y)
	end

	defp decode_instructions(encoded) do
		encoded
		|> Enum.map(fn encoded -> Regex.run(~r/([A-Z])([0-9]+)/, encoded) end)
		|> Enum.map(fn [_, cmd, strval] ->
			{val, _} = Integer.parse(strval)
			{
				case cmd do
					"N" -> 0
					"E" -> 90
					"S" -> 180
					"W" -> 270
					cmd -> cmd
				end, 
				val
			} 
		end)
	end

	defp navigate_waypoint(instructions, {{wx, wy}, {x, y}}) do
		case instructions do
			[] -> {x, y}
			[current_instruction | rest] ->
				case current_instruction do
					{0, val} -> navigate_waypoint(rest, {{wx, wy + val}, {x, y}})
					{90, val} -> navigate_waypoint(rest, {{wx + val, wy}, {x, y}})
					{180, val} -> navigate_waypoint(rest, {{wx, wy - val}, {x, y}})
					{270, val} -> navigate_waypoint(rest, {{wx - val, wy}, {x, y}})
					{"R", val} -> navigate_waypoint(rest, {rotate_waypoint(:right, {wx, wy}, val), {x, y}})
					{"L", val} -> navigate_waypoint(rest, {rotate_waypoint(:left, {wx, wy}, val), {x, y}})
					{"F", val} -> navigate_waypoint(rest, {{wx, wy}, {x + (wx * val), y + (wy * val)}})
				end
		end
	end

	defp rotate_waypoint(verse, {x, y}, amount) do
		case amount do
			0 -> {x, y}
			90 when verse == :right -> {y, -x}
			270 when verse == :left -> {y, -x}
			180 -> {-x, -y}
			270 when verse == :right -> {-y, x}
			90 when verse == :left -> {-y, x}
		end
	end

	defp navigate(instructions, {direction, {x, y}}) do
		case instructions do
			[] -> {x, y}
			[current_instruction | rest] ->
				case current_instruction do
					{0, val} -> navigate(rest, {direction, {x, y + val}})
					{90, val} -> navigate(rest, {direction, {x + val, y}})
					{180, val} -> navigate(rest, {direction, {x, y - val}})
					{270, val} -> navigate(rest, {direction, {x - val, y}})
					{"R", val} -> navigate(rest, {rotate(:right, direction, val), {x, y}})
					{"L", val} -> navigate(rest, {rotate(:left, direction, val), {x, y}})
					{"F", val} -> navigate([{direction, val} | rest], {direction, {x, y}})
				end
		end
	end

	defp rotate(verse, direction, val) do
		new_direction = 
			direction + case verse do
				:right -> val
				:left -> -val
			end
		case new_direction do
			d when d >= 360 -> rotate(:left, d, 360)
			d when d < 0 -> rotate(:right, d, 360)
			d -> d
		end
	end
end
