defmodule Day3 do
	def part1 do
		Input.read(3)
		|> Enum.reduce(
			{0, []},
			fn (current, {cursor, prev}) ->
				{
					rem(cursor + 3, String.length(current)),
					[String.at(current, cursor) | prev]
				}
			end
		)
		|> elem(1)
		|> Enum.count(&(&1 == "#"))
	end
end