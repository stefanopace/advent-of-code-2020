defmodule Day13 do
	@doc """
	## Examples
		iex> Input.read(13) |> Day13.part1
		6568
	"""
	def part1(input) do
		{timestamp, ids} = 
			input
			|> decode_input

		ids
		|> Enum.map(fn {_index, id} -> id end)
		|> Enum.map(fn id -> %{id: id, delay: id - rem(timestamp, id)} end)
		|> Enum.min_by(&(&1.delay))
		|> (fn %{id: id, delay: delay} -> id * delay end).()
	end
	
	@doc """
	## Examples
		iex> Input.read(13) |> Day13.part2
		554865447501099
	"""
	def part2(input) do
		{_timestamp, ids} = 
			input
			|> decode_input

		[ first | rest ] = ids

		rest
		|> Enum.map(&([first, &1]))
		|> Enum.map(fn [{index_a, id_a}, {index_b, id_b}] -> analyze(id_a, id_b, index_b - index_a) end)
		|> solve		

	end

	def solve([{c1, a}, {c2, b} | rest]) do
		solve([simulate(c1, a, c2, b) | rest])
	end
	def solve([{solution, _}]) do
		solution
	end

	def simulate(c1, a, c2, b) do
		Stream.iterate(0, &(&1 + 1))
		|> Stream.map(&(a * &1))
		|> Stream.map(&(&1 + c1))
		|> Stream.filter(fn ts1 -> rem(ts1 - c2, b) == 0 end)
		|> Stream.take(2) |> Enum.to_list
		|> (fn [ts1, ts2] -> {ts1, ts2 - ts1} end).()
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
