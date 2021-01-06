defmodule Day4.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day4/input") |> Day4.Part1.solve
		230
	"""
	def solve(input) do
		input
		|> parse_documents
		|> Enum.count(&are_required_fields_present?/1)
	end

	def parse_documents(lines) do
		lines
		|> Input.split_on_blank_lines
		|> Enum.map(fn doc -> Enum.flat_map(doc, fn record -> String.split(record, " ") end) end)
		|> Enum.map(fn doc -> Enum.map(doc, 
			fn record ->
				record
				|> Input.regex_match(~r"(.*):(.*)")
				|> (fn {k, v} -> {String.to_atom(k), v} end).()
			end)
		end)
	end

	def are_required_fields_present?(doc) do
		[:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
		|> Enum.all?(fn field -> Keyword.has_key?(doc, field) end)
	end

end