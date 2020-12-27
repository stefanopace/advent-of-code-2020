defmodule Day13 do
	@doc """
	## Examples
		iex> Day13.part1
		6568
	"""
	def part1 do
		{timestamp, ids} = 
			Input.read(13)
			|> decode_input

		ids
		|> Enum.map(fn {_index, id} -> id end)
		|> Enum.map(fn id -> %{id: id, delay: id - rem(timestamp, id)} end)
		|> Enum.min_by(&(&1.delay))
		|> (fn %{id: id, delay: delay} -> id * delay end).()
    end

	defp decode_input([str_timestamp, ids_encoded]) do
		{timestamp, _} = Integer.parse(str_timestamp)
		ids =
			ids_encoded 
			|> String.split(",")
			|> Enum.with_index
			|> Enum.filter(fn {id, _index} -> id != "x" end)
			|> Enum.map(fn {id, index} -> {index, Integer.parse(id) |> elem(0)} end)

		{timestamp, ids}
	end

	@doc """
	## Examples
		iex> Day13.part2
		:error
	"""
	def part2 do
		:error
	end
end
