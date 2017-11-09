defmodule Morse do

  # Some test samples to decode

  def base, do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '

  def rolled, do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '

  def decode(signal) do
    table = decode_table()
    decode(signal, table, table)
  end

  def decode([], _, _), do: []
  def decode([?-  | signal], {:node, _, long, _}, table),  do: decode(signal, long, table)
  def decode([?.  | signal], {:node, _, _, short}, table), do: decode(signal, short, table)
  def decode([?\s | signal], {:node, :na, _, _}, table),   do: decode(signal, table, table)
  def decode([_   | signal], {:node, char, _, _}, table),  do: [char | decode(signal, table, table)]

  def encode(text) do
    table = encode_table()
    encode(text, [], table)
  end

  defp encode([], all, _), do: unpack(all, [])
  defp encode([char | rest], sofar, table) do
    code = lookup(char, table)
    encode(rest, [code | sofar], table)
  end

  defp unpack([], done), do: done
  defp unpack([code | rest], sofar), do: unpack(rest, code ++ [?\s | sofar])

  # Naive lookup

  #defp encode_table, do: codes()

  #defp lookup(char, table) do
  #  List.keyfind(table, char, 0)
  #  |> elem(1)
  #end

  # Constant lookup

  defp encode_table do
    codes()
    |> fill(0)
    |> List.to_tuple
  end

  defp lookup(char, table), do: elem(table, char)

  defp fill([], _), do: []
  defp fill([{n, code} | codes], n), do: [code | fill(codes, n + 1)]
  defp fill(codes, n), do: [:na | fill(codes, n + 1)]

  # Decoding tree

  defp decode_table do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  defp codes do
    [{32, '..--'},
     {37,'.--.--'},
     {44,'--..--'},
     {45,'-....-'},
     {46,'.-.-.-'},
     {47,'.-----'},
     {48,'-----'},
     {49,'.----'},
     {50,'..---'},
     {51,'...--'},
     {52,'....-'},
     {53,'.....'},
     {54,'-....'},
     {55,'--...'},
     {56,'---..'},
     {57,'----.'},
     {58,'---...'},
     {61,'.----.'},
     {63,'..--..'},
     {64,'.--.-.'},
     {97,'.-'},
     {98,'-...'},
     {99,'-.-.'},
     {100,'-..'},
     {101,'.'},
     {102,'..-.'},
     {103,'--.'},
     {104,'....'},
     {105,'..'},
     {106,'.---'},
     {107,'-.-'},
     {108,'.-..'},
     {109,'--'},
     {110,'-.'},
     {111,'---'},
     {112,'.--.'},
     {113,'--.-'},
     {114,'.-.'},
     {115,'...'},
     {116,'-'},
     {117,'..-'},
     {118,'...-'},
     {119,'.--'},
     {120,'-..-'},
     {121,'-.--'},
     {122,'--..'}]
  end
end