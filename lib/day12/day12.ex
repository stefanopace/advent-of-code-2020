defmodule Day12 do
	@doc """
	## Examples
		iex> Day12.part1
		1152
	"""
	def part1 do
		Input.read(12)
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
		|> navigate({90, {0, 0}})
		|> (fn {x, y} -> abs(x) + abs(y) end).()
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

	@doc """
	## Examples
		iex> Day12.part2
		:error
	"""
	def part2 do
		:error
	end
end
