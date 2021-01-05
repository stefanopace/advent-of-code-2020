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

		# iex> Input.read(24) |> Day24.part1
		# :result
	"""
	def part1(input) do
		input
		|> Enum.map(&String.graphemes/1)
		|> Enum.map(&decode_directions/1)
	end

	defp decode_directions(encoded), do: decode_directions(encoded, [])
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

	@doc """
	## Examples
		iex> Input.read(24) |> Day24.part2
		:result
	"""
	def part2(_input) do
		:result
	end
end
