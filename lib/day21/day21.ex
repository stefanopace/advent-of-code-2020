defmodule Day21 do
	@doc """
	## Examples
		iex> [
		...>	"mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
		...>	"trh fvjkl sbzzf mxmxvkd (contains dairy)",
		...>	"sqjhc fvjkl (contains soy)",
		...>	"sqjhc mxmxvkd sbzzf (contains fish)"
		...> ] |> Day21.part1
		5

		iex> Input.read(21) |> Day21.part1
		2075
	"""
	def part1(input) do
		list =
			input
			|> decode
		
		allergenes_map =
			list
			|> rearrange
			|> intersect
			|> exclude([])
		
		allergenes =
			allergenes_map
			|> Enum.map(fn {_name, ingredient_set} ->
				ingredient_set |> MapSet.to_list |> List.first
			end)

		_count_non_allergenes =
			list
			|> Enum.map(fn {ingredients, _allergenes} -> 
				ingredients
			end)
			|> List.flatten
			|> Enum.count(fn ingredient ->
				not Enum.member?(allergenes, ingredient)
			end)
	end

	@doc """
	## Examples
		iex> [
		...>	"mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
		...>	"trh fvjkl sbzzf mxmxvkd (contains dairy)",
		...>	"sqjhc fvjkl (contains soy)",
		...>	"sqjhc mxmxvkd sbzzf (contains fish)"
		...> ] |> Day21.part2
		"mxmxvkd,sqjhc,fvjkl"

		iex> Input.read(21) |> Day21.part2
		"zfcqk,mdtvbb,ggdbl,frpvd,mgczn,zsfzq,kdqls,kktsjbh"
	"""
	def part2(input) do
		list =
			input
			|> decode
		
		allergenes_map =
			list
			|> rearrange
			|> intersect
			|> exclude([])
		
		allergenes_map
		|> Enum.map(fn {allergene, ingredient} -> 
			{allergene, MapSet.to_list(ingredient) |> List.first}
		end)
		|> Enum.sort_by(fn {allergene, _ingreidient} -> allergene end)
		|> Enum.map(fn {_allergene, ingredient} -> ingredient end)
		|> Enum.join(",")
	end

	def exclude([], sure), do: sure
	def exclude(dubious, sure) do

		dubious =
			dubious
			|> Enum.map(fn {allergene, ingredients} -> 
				{
					allergene,
					sure
					|> Enum.reduce(ingredients, fn {_name, sure}, result -> 
						MapSet.difference(result, sure)
					end)
				}
			end)
		
		sure2 =
			dubious
			|> Enum.filter(fn {_allergene, ingredients} -> 
				MapSet.size(ingredients) == 1
			end)
		
		exclude(dubious -- sure2, sure ++ sure2)
	end

	def intersect(list) do
		list
		|> Enum.map(fn {allergene, possibilities} -> 
			{
				allergene,
				possibilities
				|> Enum.reduce(&MapSet.intersection/2)
			}
		end)
	end

	def rearrange(rows) do
		rows
		|> Enum.map(fn {_ingredients, allergenes} -> 
			allergenes
		end)
		|> List.flatten
		|> Enum.sort
		|> Enum.dedup
		|> Enum.map(fn allergene ->
			{
				allergene,
				rows
				|> Enum.filter(fn {_ingredients, allergenes} ->
					Enum.member?(allergenes, allergene)
				end)
				|> Enum.map(fn {ingredients, _allergenes} -> MapSet.new(ingredients) end)
			}
		end)
	end

	def decode(lines) do
		lines
		|> Enum.map(fn line -> Regex.run(~r/(.*) \(contains (.*)\)/, line) end)
		|> Enum.map(fn [_, ingredients, allergenes] ->
			{String.split(ingredients), String.split(allergenes, ", ")}
		end)
	end

end
