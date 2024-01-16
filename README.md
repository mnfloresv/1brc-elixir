# 1BRC in Elixir

Elixir implementation of [The One Billion Row Challenge](https://github.com/gunnarmorling/1brc)

## Preface

This is my first program in Elixir, so the code doesn't try to achieve very high speed but rather focuses on practicing with the language.

My focus has been to create a simple solution that runs in parallel, prioritizing code legibility and without loading the entire file into memory.

Low-level optimizations haven't been addressed.

## Running the challenge

I am using Elixir 1.16.0 (compiled with Erlang/OTP 26)

### Create measurements

It is a direct translation of the Java implementation `dev.morling.onebrc.CreateMeasurements`.

Creates the file `measurements.txt` in the root directory of this project with a configurable number of random measurement values.

This will take a few minutes. Attention: the generated file has a size of approx. 12 GB, so make sure to have enough diskspace.

```
elixir create_measurements.exs 1000000000
```

### Calculate averages

Calculates the average values for the file `measurements.txt`

```
time elixir calculate_average.exs
```
