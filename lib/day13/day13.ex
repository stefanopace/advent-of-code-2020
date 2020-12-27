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
	
	@doc """
	## Examples
		iex> Day13.part2
		1068781
	"""
	def part2 do
# 112969600000000
# 112977810000000

		{_timestamp, ids} = 
			["939", "7,13,x,x,59,x,31,19"]
			|> decode_input
		# {_timestamp, ids} = 
		# 	Input.read(13)
		# 	|> decode_input

		ids
		|> Enum.chunk_every(2,1,:discard)
		|> Enum.map(fn pair = [{index_a, id_a}, {index_b, id_b}] -> {pair, analyze(id_a, id_b, index_b - index_a)} end)
		
		# fixed_ids = ids |> Enum.map(fn {index, id} -> {index - step_index, id} end) 

	end

	def analyze(a, b, diff) do
		Stream.iterate(0, &(&1 + 1))
		|> Stream.map(&(a * &1))
		|> Stream.map(&({&1, &1 + diff}))
		|> Stream.filter(fn {_a, candidate_b} -> rem(candidate_b, b) == 0 end)
		|> Stream.take(2) |> Enum.to_list
		|> (fn [{a, _}, {b, _}] -> {a, b - a} end).()
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
end
