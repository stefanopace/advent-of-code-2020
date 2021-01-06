defmodule Input do
	def read(day_num) when is_number(day_num)do
		{:ok, input} = File.read("./lib/day#{day_num}/input")
		String.split(input, "\n")
	end

	def read(file) do
		{:ok, input} = File.read(file)
		String.split(input, "\n")
	end

	def to_integers(str_integers), do: str_integers |> Stream.map(&String.to_integer/1)

	def regex_match(string, regex) do
		case Regex.run(regex, string) do
			nil -> nil
			match -> match |> tl |> List.to_tuple
		end
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