defmodule Input do
	def read(day_num) do
		{:ok, input} = File.read("./lib/day#{day_num}/input")
		String.split(input, "\n")
	end

	def split_on_blank_lines(list) do
		list
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
		|> Enum.map(&Enum.reverse/1)
	end
end