defmodule Day14 do
	@doc """
	## Examples
		iex> Day14.part1
		:error
	"""
	def part1 do
		Input.read(14)
		|> Enum.map(&decode/1)
	end

	defp decode(line) do
		case Regex.run(~r/(mask|mem)(?:\[([0-9]+)\])? = ([0-9X]+)/, line) do
			[_, "mem", index, value] -> 
				{index, _} = Integer.parse(index)
				{value, _} = Integer.parse(value)
				{:mem, index, value}
			[_, "mask", _, value] -> 
				{:mask, value}
		end
	end

	@doc """
	## Examples
		iex> Day14.part2
		:error
	"""
	def part2 do
		:error
	end
end
