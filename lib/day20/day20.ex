defmodule Day20 do
	@doc """
	## Examples
		iex> Input.read("./lib/day20/input_example") |> Day20.part1
		20899048083289

		# test too slow
		# iex> Input.read(20) |> Day20.part1
		# 21599955909991
	"""
	def part1(input) do
		input
		|> parse_tiles
		|> pick_one_tile
		|> connect_other_tiles
		|> filter_only_corners_id
		|> Enum.reduce(&Kernel.*/2)
	end

	@doc """
	## Examples
		iex> Input.read("./lib/day20/input_example") |> Day20.part2
		273
	
		# test too slow
		# iex> Input.read(20) |> Day20.part2
		# 2495
	"""
	def part2(input) do
		input
		|> parse_tiles
		|> pick_one_tile
		|> connect_other_tiles
		|> remove_edges_and_ids
		|> merge_all_tiles
		|> count_monsters
		|> compute_sea_roughness
	end

	defp compute_sea_roughness({canvas, count}) do
		canvas
		|> Enum.count(fn {_coords, pixel} -> pixel == "#" end)
		|> Kernel.-(count * 15)
	end

	defp count_monsters(canvas) do
		monster = [
			"                  # ",
			"#    ##    ##    ###",
			" #  #  #  #  #  #   "
		] |> parse_monster

		count =
			rotations_of({nil, monster})
			|> Enum.map(fn {nil, monster} -> monster end)
			|> Enum.map(fn monster -> count_monster_rotation(canvas |> Map.new, monster) end)
			|> Enum.sum
		
		{canvas, count}
	end

	defp count_monster_rotation(map, monster) do
		monster_width =
			monster
			|> Enum.map(fn {{x, _y}, _pixel} -> x end)
			|> Enum.max
		
		monster_height =
			monster
			|> Enum.map(fn {{_x, y}, _pixel} -> y end)
			|> Enum.max

		map
		|> Enum.count(fn {{x, y}, _} -> 
			for dx <- 0..monster_width, dy <- 0..monster_height do
				Map.get(monster, {dx, dy}) == " " or Map.get(monster, {dx, dy}) == Map.get(map, {x + dx, y + dy})
			end
			|> Enum.all?
		end)
	end

	def parse_monster(encoded_data) do
		encoded_data
		|> Enum.with_index
		|> Enum.map(fn {row, y} ->
			row
			|> String.graphemes
			|> Enum.with_index
			|> Enum.map(fn {pixel, x} -> {{x, y}, pixel} end)
		end)
		|> List.flatten
		|> Map.new
	end

	defp merge_all_tiles(canvas) do
		canvas
		|> Enum.map(fn {{tile_x, tile_y}, tile} -> 
			tile
			|> Enum.map(fn {{pixel_x, pixel_y}, pixel} -> 
				{
					{tile_x * 8 + pixel_x, tile_y * 8 + pixel_y}, pixel
				} 
			end)
		end)
		|> List.flatten
	end

	defp remove_edges_and_ids(canvas) do
		canvas
		|> Enum.reject(fn {_coords, {id, _data}} -> id == :edge end)
		|> Enum.map(fn {coords, {_id, data}} -> 
			{
				coords,
				data
				|> Enum.reject(fn {{x, y}, _pixel} -> x == 0 or x == 9 or y == 0 or y == 9 end)
				|> Enum.map(fn {{x, y}, pixel} -> {{x - 1, y - 1}, pixel} end)
			}
		end)	
	end

	defp filter_only_corners_id(canvas) do
		canvas = 
			canvas
			|> Enum.reject(fn {_coords, {id, _data}} -> id == :edge end)
			|> Enum.map(fn {coords, {id, _data}} -> {coords, id} end)
		
		[
			canvas |> Enum.min_by(fn {{x, y}, _id} -> x + y end),
			canvas |> Enum.min_by(fn {{x, y}, _id} -> x - y end),
			canvas |> Enum.min_by(fn {{x, y}, _id} -> -x + y end),
			canvas |> Enum.min_by(fn {{x, y}, _id} -> -x - y end)
		]
		|> Enum.map(fn {_coords, id} -> id end)
	end

	defp connect_other_tiles({[], canvas}) do
		canvas	
	end
	defp connect_other_tiles({tile_bag, canvas}) do
		canvas
		|> find_a_tile_missing_a_neighbor
		|> find_the_missing_neighbor(tile_bag)
		|> connect_other_tiles
	end

	defp find_the_missing_neighbor({canvas, {{{x, y}, tile}, direction = {dx, dy}}}, tile_bag) do
		neighbor = {neighbor_id, _data} = 
			tile_bag
			|> Enum.find_value(
				{:edge, nil}, 
				fn tile_in_the_bag -> 
					rotations_of(tile_in_the_bag)
					|> Enum.find(false, fn rotated_tile -> tile |> connects?(rotated_tile, direction) end)
				end)
			
		{
			tile_bag |> Enum.reject(fn {id, _data} -> id == neighbor_id end), 
			Map.put(canvas, {x + dx, y + dy}, neighbor)
		}
	end

	defp rotations_of(tile) do
		r90 = rotate(tile)
		r180 = rotate(r90)
		r270 = rotate(r180)
		flipped = flip(tile)
		fr90 = rotate(flipped)
		fr180 = rotate(fr90)
		fr270 = rotate(fr180)
		[tile, r90, r180, r270, flipped, fr90, fr180, fr270]
	end

	defp rotate({id, data}) do
		width =
			data
			|> Enum.map(fn {{x, _y}, _pixel} -> x end)
			|> Enum.max

		rotated = 
			data
			|> Enum.map(fn {{x, y}, pixel} ->
				{{y, width - x}, pixel}
			end)
			|> Map.new

		{id, rotated}
	end

	defp flip({id, data}) do
		width =
			data
			|> Enum.map(fn {{x, _y}, _pixel} -> x end)
			|> Enum.max

		flipped =
			data
			|> Enum.map(fn {{x, y}, pixel} ->
				{{width - x, y}, pixel}
			end)
			|> Map.new
		
		{id, flipped}
	end

	defp connects?(tile1, tile2, direction) do
		case direction do
			{0, -1} -> connects_top?(tile1, tile2)
			{1, 0} -> connects_right?(tile1, tile2)
			{0, 1} -> connects_bottom?(tile1, tile2)
			{-1, 0} -> connects_left?(tile1, tile2)
		end
	end

	defp connects_top?(tile1, tile2) do
		top_border(tile1) == bottom_border(tile2)
	end

	defp connects_right?(tile1, tile2) do
		right_border(tile1) == left_border(tile2)
	end

	defp connects_bottom?(tile1, tile2) do
		bottom_border(tile1) == top_border(tile2)
	end

	defp connects_left?(tile1, tile2) do
		left_border(tile1) == right_border(tile2)
	end

	defp top_border({_id, tile}) do
		tile
		|> Enum.filter(fn {{_x, y}, _pixel} -> y == 0 end)
		|> Enum.map(fn {{x, _y}, pixel} -> {x, pixel} end)
		|> Map.new
	end

	defp bottom_border({_id, tile}) do
		tile
		|> Enum.filter(fn {{_x, y}, _pixel} -> y == 9 end)
		|> Enum.map(fn {{x, _y}, pixel} -> {x, pixel} end)
		|> Map.new
	end

	defp left_border({_id, tile}) do
		tile
		|> Enum.filter(fn {{x, _y}, _pixel} -> x == 0 end)
		|> Enum.map(fn {{_x, y}, pixel} -> {y, pixel} end)
		|> Map.new
	end

	defp right_border({_id, tile}) do
		tile
		|> Enum.filter(fn {{x, _y}, _pixel} -> x == 9 end)
		|> Enum.map(fn {{_x, y}, pixel} -> {y, pixel} end)
		|> Map.new
	end

	defp find_a_tile_missing_a_neighbor(canvas) do
		canvas
		|> Enum.reject(fn {_coords, {id, _data}} -> id == :edge end)
		|> Enum.find_value(fn tile = {{x, y}, _data} ->
			missing = 
				[{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
				|> Enum.find(fn {dx, dy} -> 
					not Map.has_key?(canvas, {x + dx, y + dy})
				end)
			
			if missing, do: {canvas, {tile, missing}}, else: false
		end)
	end

	defp pick_one_tile(_tile_bag = [first | rest]) do
		{rest, %{{0, 0} => first}}
	end

	defp parse_tiles(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(&parse_tile/1)
	end

	defp parse_tile([encoded_id | encoded_data]) do
		id = Regex.run(~r/Tile (\d+):/, encoded_id) |> Enum.at(1) |> Integer.parse |> elem(0)

		data =
			encoded_data
			|> Enum.with_index
			|> Enum.map(fn {row, y} ->
				row
				|> String.graphemes
				|> Enum.with_index
				|> Enum.map(fn {pixel, x} -> {{x, y}, pixel} end)
			end)
			|> List.flatten
			|> Map.new

		{id, data}
	end
end
