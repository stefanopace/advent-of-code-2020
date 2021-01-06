defmodule Day24 do
	@doc """
	## Examples
		iex> [
		...>	"sesenwnenenewseeswwswswwnenewsewsw",
		...>	"neeenesenwnwwswnenewnwwsewnenwseswesw",
		...>	"seswneswswsenwwnwse",
		...>	"nwnwneseeswswnenewneswwnewseswneseene",
		...>	"swweswneswnenwsewnwneneseenw",
		...>	"eesenwseswswnenwswnwnwsewwnwsene",
		...>	"sewnenenenesenwsewnenwwwse",
		...>	"wenwwweseeeweswwwnwwe",
		...>	"wsweesenenewnwwnwsenewsenwwsesesenwne",
		...>	"neeswseenwwswnwswswnw",
		...>	"nenwswwsewswnenenewsenwsenwnesesenew",
		...>	"enewnwewneswsewnwswenweswnenwsenwsw",
		...>	"sweneswneswneneenwnewenewwneswswnese",
		...>	"swwesenesewenwneswnwwneseswwne",
		...>	"enesenwswwswneneswsenwnewswseenwsese",
		...>	"wnwnesenesenenwwnenwsewesewsesesew",
		...>	"nenewswnwewswnenesenwnesewesw",
		...>	"eneswnwswnwsenenwnwnwwseeswneewsenese",
		...>	"neswnwewnwnwseenwseesewsenwsweewe",
		...>	"wseweeenwnesenwwwswnew"
		...> ] |> Day24.part1
		10

		iex> Input.read(24) |> Day24.part1
		330
	"""
	def part1(input) do
		input
		|> Enum.map(&decode_directions/1)
		|> Enum.reduce({%{}, {0, 0}}, &flip_tile/2)
		|> elem(0)
		|> Enum.count(fn {_, color} -> color == :black end)
	end

	@doc """
	## Examples
		iex> [
		...>	"sesenwnenenewseeswwswswwnenewsewsw",
		...>	"neeenesenwnwwswnenewnwwsewnenwseswesw",
		...>	"seswneswswsenwwnwse",
		...>	"nwnwneseeswswnenewneswwnewseswneseene",
		...>	"swweswneswnenwsewnwneneseenw",
		...>	"eesenwseswswnenwswnwnwsewwnwsene",
		...>	"sewnenenenesenwsewnenwwwse",
		...>	"wenwwweseeeweswwwnwwe",
		...>	"wsweesenenewnwwnwsenewsenwwsesesenwne",
		...>	"neeswseenwwswnwswswnw",
		...>	"nenwswwsewswnenenewsenwsenwnesesenew",
		...>	"enewnwewneswsewnwswenweswnenwsenwsw",
		...>	"sweneswneswneneenwnewenewwneswswnese",
		...>	"swwesenesewenwneswnwwneseswwne",
		...>	"enesenwswwswneneswsenwnewswseenwsese",
		...>	"wnwnesenesenenwwnenwsewesewsesesew",
		...>	"nenewswnwewswnenesenwnesewesw",
		...>	"eneswnwswnwsenenwnwnwwseeswneewsenese",
		...>	"neswnwewnwnwseenwseesewsenwsweewe",
		...>	"wseweeenwnesenwwwswnew"
		...> ] |> Day24.part2
		2208

		iex> Input.read(24) |> Day24.part2
		3711
	"""
	def part2(input) do
		day0_floor = 
			input
			|> Enum.map(&decode_directions/1)
			|> Enum.reduce({%{}, {0, 0}}, &flip_tile/2)
			|> elem(0)
		
		day0_floor
		|> Stream.iterate(&apply_rules/1)
		|> Enum.at(100)
		|> Enum.count(fn {_, color} -> color == :black end)
	end

	defp apply_rules(floor) do
		floor
		|> reset_counters
		|> count_black_neighbors
		|> update_colors
	end

	defp update_colors(floor) do
		floor
		|> Enum.map(
			fn 
				{coords, {:black, count}} ->
					cond do
						count == 0 or count > 2 -> {coords, :white}
						true -> {coords, :black}
					end
				{coords, {:white, count}} ->
					cond do
						count == 2 -> {coords, :black}
						true -> {coords, :white}
					end
			end
		)
		|> Map.new
	end

	defp count_black_neighbors(floor) do
		floor
		|> Enum.reduce(floor, fn 
			{______, {:white, _}}, floor -> floor
			{{x, y}, {:black, _}}, floor -> 
				[{0, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, 0}, {-1, 1}] 
				|> Enum.reduce(floor, 
					fn ({dx, dy}, floor) -> 
						floor
						|> Map.update({x + dx, y + dy}, {:white, 1}, 
							fn {color, count} ->
								{color, count + 1} 
							end
						)
					end
				)
		end)
	end

	defp reset_counters(floor) do
		floor
		|> Enum.map(fn 
			{coords, color} -> {coords, {color, 0}}
		end)
		|> Map.new
	end

	defp flip_tile([], {floor, current_tile}) do
		case floor[current_tile] do
			:black -> {Map.put(floor, current_tile, :white), {0, 0}}
			:white -> {Map.put(floor, current_tile, :black), {0, 0}}
			______ -> {Map.put(floor, current_tile, :black), {0, 0}}
		end
	end
	defp flip_tile([current_direction | rest], {floor, {x, y}}) do
		case current_direction do
			:north_east -> flip_tile(rest, {floor, {x, y + 1}})
			:east -> flip_tile(rest, {floor, {x + 1, y}})
			:south_east -> flip_tile(rest, {floor, {x + 1, y - 1}})
			:south_west -> flip_tile(rest, {floor, {x, y - 1}})
			:west -> flip_tile(rest, {floor, {x - 1, y}})
			:north_west -> flip_tile(rest, {floor, {x - 1, y + 1}})
		end
	end

	defp decode_directions(encoded), do: decode_directions(encoded |> String.graphemes, [])
	defp decode_directions(encoded, decoded) do
		case encoded do
			[] -> decoded |> Enum.reverse
			["s", "e" | rest] -> decode_directions(rest, [:south_east | decoded])
			["s", "w" | rest] -> decode_directions(rest, [:south_west | decoded])
			["n", "w" | rest] -> decode_directions(rest, [:north_west | decoded])
			["n", "e" | rest] -> decode_directions(rest, [:north_east | decoded])
			["e" | rest] -> decode_directions(rest, [:east | decoded])
			["w" | rest] -> decode_directions(rest, [:west | decoded])
		end
	end
end
