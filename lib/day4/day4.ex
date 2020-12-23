defmodule Day4 do

	def parse_documents(lines) do
		lines
		|> Enum.chunk_while([], 
			fn element, acc -> if element != "" do
					{:cont, [element | acc]}
				else
					{:cont, acc, []}
				end
			end,
			fn 
				[] -> {:cont, []}
				acc -> {:cont, acc, []}
			end
		)
		|> Enum.map(fn doc -> Enum.flat_map(doc, fn record -> String.split(record, " ") end) end)
		|> Enum.map(fn doc -> Enum.map(doc, fn record -> 
			[_all, k, v] = Regex.run(~r"(.*):(.*)", record)
			{String.to_atom(k), v}
			end )
		end )
	end

	def valid(doc) do
		[:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
		|> Enum.all?(fn field -> Keyword.has_key?(doc, field) end)
	end

	@doc """
	## Examples
		iex> Day4.part1
		230
	"""
	def part1 do
		Input.read(4)
		|> parse_documents
		|> Enum.filter(&valid/1)
		|> Enum.count
	end
	
end