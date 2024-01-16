defmodule CalculateAverage do

  @measurement_file "measurements.txt"

  def main do
    File.stream!(@measurement_file, :line)
    |> Stream.chunk_every(10_000)
    |> Task.async_stream(&process_chunk/1, max_concurrency: System.schedulers_online())
    |> Stream.map(fn {:ok, val} -> val end)
    |> Enum.reduce(%{}, fn map, acc -> Map.merge(acc, map, &merge_stats/3) end)
    |> Enum.sort()
    |> display()
  end

  defp process_chunk(lines) do
    lines
    |> Stream.map(&parse_line/1)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.into(%{}, &temperature_stats/1)
  end

  defp temperature_stats({id, values}) do
    {id, {length(values), Enum.min(values), Enum.max(values), Enum.sum(values)}}
  end

  defp parse_line(line) do
    [id, temperature] = :binary.split(String.trim_trailing(line), ";")
    {id, String.to_float(temperature)}
  end

  defp merge_stats(_id, {count1, min1, max1, sum1}, {count2, min2, max2, sum2}) do
    {count1 + count2, min(min1, min2), max(max1, max2), sum1 + sum2}
  end

  defp display(results) do
    [
      "{",
      results
      |> Enum.map(fn {id, {count, min, max, sum}} ->
        [id, "=", Float.to_string(min), "/", :erlang.float_to_binary(sum/count, decimals: 1), "/", Float.to_string(max)]
      end)
      |> Enum.intersperse(", "),
      "}"
    ]
    |> IO.puts()
  end
end

CalculateAverage.main
