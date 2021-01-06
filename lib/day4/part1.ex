defmodule Day4.Part1 do

	@doc """
	## Examples
		iex> Input.read(4) |> Day4.Part1.solve
		230
	"""
	def solve(input) do
		input
		|> parse_documents
		|> Enum.filter(&required_fields_are_present/1)
		|> Enum.count
	end

	def parse_documents(lines) do
		lines
		|> Input.split_on_blank_lines
		|> Enum.map(fn doc -> Enum.flat_map(doc, fn record -> String.split(record, " ") end) end)
		|> Enum.map(fn doc -> Enum.map(doc, fn record -> 
			[_all, k, v] = Regex.run(~r"(.*):(.*)", record)
			{String.to_atom(k), v}
			end )
		end )
	end

	def required_fields_are_present(doc) do
		[:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
		|> Enum.all?(fn field -> Keyword.has_key?(doc, field) end)
	end

end