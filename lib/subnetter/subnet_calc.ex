defmodule SubnetFigurin do
  def main(original_ip_address, original_mask) do
    original_decimal_ip_address_list = String.split(original_ip_address, ".")
    original_decimal_mask_list = String.split(original_mask, ".")

    original_decimal_ip_address_numbers =
      for octet <- original_decimal_ip_address_list do
        String.to_integer(octet)
      end

    original_decimal_mask_numbers =
      for octet <- original_decimal_mask_list do
        String.to_integer(octet)
      end

    original_binary_ip_address_list =
      for octet <- original_decimal_ip_address_numbers do
        decimal_to_binary(octet, "", [128, 64, 32, 16, 8, 4, 2, 1])
      end

    original_binary_mask_list =
      for octet <- original_decimal_mask_numbers do
        decimal_to_binary(octet, "", [128, 64, 32, 16, 8, 4, 2, 1])
      end

    joined_ip = Enum.join(original_binary_ip_address_list)
    joined_mask = Enum.join(original_binary_mask_list)

    number_of_ones_in_mask =
      joined_mask
      |> String.graphemes()
      |> Enum.count(&(&1 == "1"))

    magic_octet = div(number_of_ones_in_mask, 8)
    number_of_bits_into_magic_octet = rem(number_of_ones_in_mask, 8)

    binary_ip_network_portion = String.slice(joined_ip, 0..(number_of_ones_in_mask - 1))
    bin_host_portion_of_ip = String.slice(joined_ip, (number_of_ones_in_mask - 32)..31)

    magic_octet_ip_msd = String.slice(joined_ip, (8 * magic_octet)..number_of_ones_in_mask)
    magic_octet_ip_lsd = String.slice(joined_ip, number_of_ones_in_mask..(8 * (magic_octet + 1)))

    zeroes_for_subnet_address_and_mask = List.duplicate("0", 32 - number_of_ones_in_mask)

    ones_for_broadcast_address = List.duplicate("1", 32 - number_of_ones_in_mask)
    ones_for_subnet_mask = List.duplicate("1", number_of_ones_in_mask)

    binary_subnet_address =
      Enum.join(binary_ip_network_portion, zeroes_for_subnet_address_and_mask)

    binary_broadcast_address = Enum.join(binary_ip_network_portion, ones_for_broadcast_address)
  end

  def decimal_to_binary(value, binary, [head | tail]) do
    new_value = value - head

    cond do
      new_value >= 0 ->
        new_binary = "#{binary}" <> "1"
        decimal_to_binary(new_value, new_binary, tail)

      new_value < 0 ->
        new_binary = "#{binary}" <> "0"
        decimal_to_binary(value, new_binary, tail)
    end
  end

  def decimal_to_binary(value, binary, []) do
    IO.inspect(binary, label: "BINARY")
  end

  def binary_to_decimal(binary) do
    format_binary(binary)
    |> add_bits_base_2([128, 64, 32, 16, 8, 4, 2, 1], 0)
  end

  defp format_binary(binary) do
    binary_list = String.graphemes(binary)
    Enum.map(binary_list, &String.to_integer/1)
  end

  defp add_bits_base_2([binary_head | binary_tail], [value_head | value_tail], value) do
    new_value = binary_head * value_head + value
    add_bits_base_2(binary_tail, value_tail, new_value)
  end

  defp add_bits_base_2([], [], value) do
    IO.inspect(value, label: "VALUE")
  end
end

#     IO.inspect(value, label: "Value")
#     IO.inspect(new_value, label: "New Value")
#     IO.inspect(new_binary, label: "New Binary")
#     IO.inspect(tail, label: "Tail")

#     IO.inspect(value, label: "Value")
#     IO.inspect(new_value, label: "New Value")
#     IO.inspect(new_binary, label: "New Binary")
#     IO.inspect(tail, label: "Tail")
