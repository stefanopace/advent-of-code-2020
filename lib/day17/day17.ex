defmodule Day17 do
	@doc """
	## Examples
		iex> Input.read(17) |> Day17.part1
		247
	"""
	def part1(input) do
		input
		|> to_3d_space
		
		|> expand_edges
		|> simulate_cycle

		|> expand_edges
		|> simulate_cycle

		|> expand_edges
		|> simulate_cycle

		|> expand_edges
		|> simulate_cycle

		|> expand_edges
		|> simulate_cycle

		|> expand_edges
		|> simulate_cycle

		|> Enum.count
	end

	@doc """
	## Examples
		# test too slow
		# iex> [
		# ...>	".#.",
		# ...>	"..#",
		# ...>	"###"
		# ...> ] |> Day17.part2
		# 848

		# test too slow
		# iex> Input.read(17) |> Day17.part2
		# 1392
	"""
	def part2(input) do
		input
		|> to_4d_space
		
		|> expand_edges_4d
		|> simulate_cycle_4d

		|> expand_edges_4d
		|> simulate_cycle_4d

		|> expand_edges_4d
		|> simulate_cycle_4d

		|> expand_edges_4d
		|> simulate_cycle_4d

		|> expand_edges_4d
		|> simulate_cycle_4d

		|> expand_edges_4d
		|> simulate_cycle_4d

		|> Enum.count
	end

	defp simulate_cycle(space) do
		space
		|> Enum.map(fn {coords, status} -> 
			active_neighbors = count_active_neighbors(space, coords)
			case status do
				:active -> {coords, (if (active_neighbors == 2 or active_neighbors == 3), do: :active, else: :inactive)}
				:inactive -> {coords, (if (active_neighbors == 3), do: :active, else: :inactive)}
			end
		end)
		|> Enum.filter(
			fn {_coor, status} -> status == :active end
		)
		|> Map.new
	end

	defp simulate_cycle_4d(space) do
		space
		|> Enum.map(fn {coords, status} -> 
			active_neighbors = count_active_neighbors_4d(space, coords)
			case status do
				:active -> {coords, (if (active_neighbors == 2 or active_neighbors == 3), do: :active, else: :inactive)}
				:inactive -> {coords, (if (active_neighbors == 3), do: :active, else: :inactive)}
			end
		end)
		|> Enum.filter(
			fn {_coor, status} -> status == :active end
		)
		|> Map.new
	end

	defp count_active_neighbors_4d(space, coords = {x, y, z, w}) do
		for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dz <- [-1, 0, 1], dw <- [-1, 0, 1] do
			{x + dx, y + dy, z + dz, w + dw}
		end
		|> Kernel.--([coords])
		|> Enum.map(fn coords -> space |> Map.get(coords) end)
		|> Enum.filter(fn status -> status == :active end)
		|> Enum.count
	end

	defp count_active_neighbors(space, coords = {x, y, z}) do
		for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dz <- [-1, 0, 1] do
			{x + dx, y + dy, z + dz}
		end
		|> Kernel.--([coords])
		|> Enum.map(fn coords -> space |> Map.get(coords) end)
		|> Enum.filter(fn status -> status == :active end)
		|> Enum.count
	end

	defp expand_edges(space) do
		space
		|> Enum.map(fn {{x, y, z}, status} -> 
			for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dz <- [-1, 0, 1] do
				coord = {x + dx, y + dy, z + dz}
				case coord do
					{^x, ^y, ^z} -> {{x, y, z}, status}
					coord -> 
						unless Map.has_key?(space, coord) do
							{coord, :inactive}
						else
							{coord, nil}
						end
				end
			end
		end)
		|> List.flatten
		|> Enum.reject(
			fn {_coor, status} -> status == nil end
		)
		|> Map.new
	end

	defp expand_edges_4d(space) do
		space
		|> Enum.map(fn {{x, y, z, w}, status} -> 
			for dx <- [-1, 0, 1], dy <- [-1, 0, 1], dz <- [-1, 0, 1], dw <- [-1, 0, 1] do
				coord = {x + dx, y + dy, z + dz, w + dw}
				case coord do
					{^x, ^y, ^z, ^w} -> {{x, y, z, w}, status}
					coord -> 
						unless Map.has_key?(space, coord) do
							{coord, :inactive}
						else
							{coord, nil}
						end
				end
			end
		end)
		|> List.flatten
		|> Enum.reject(
			fn {_coor, status} -> status == nil end
		)
		|> Map.new
	end

	defp to_3d_space(lines) do
		lines
		|> Enum.with_index
		|> Enum.map(fn {line, y} -> 
			String.graphemes(line) 
			|> Enum.with_index
			|> Enum.map(fn {char, x} -> {char, {x, y, 0}} end) 
		end)
		|> List.flatten
		|> Enum.map(fn {code, coords} -> 
			case code do
				"." -> {coords, :inactive}
				"#" -> {coords, :active}
			end
		end)
		|> Enum.filter(fn {_coords, status} -> status == :active end)
		|> Map.new
	end

	defp to_4d_space(lines) do
		lines
		|> Enum.with_index
		|> Enum.map(fn {line, y} -> 
			String.graphemes(line) 
			|> Enum.with_index
			|> Enum.map(fn {char, x} -> {char, {x, y, 0, 0}} end) 
		end)
		|> List.flatten
		|> Enum.map(fn {code, coords} -> 
			case code do
				"." -> {coords, :inactive}
				"#" -> {coords, :active}
			end
		end)
		|> Enum.filter(fn {_coords, status} -> status == :active end)
		|> Map.new
	end
end
