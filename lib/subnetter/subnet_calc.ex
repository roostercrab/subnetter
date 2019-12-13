defmodule SubnetCalc do
  def main(ip, mask) do
    ip_struct = %IPStruct{}
    decimal_ip_list = String.split(ip, ".")
    decimal_mask_list = String.split(mask, ".")

    [
      ip_first_octet,
      ip_second_octet,
      ip_third_octet,
      ip_fourth_octet
    ] = decimal_ip_list

    [
      mask_first_octet,
      mask_second_octet,
      mask_third_octet,
      mask_fourth_octet
    ] = decimal_mask_list

    decimal_ip_numbers =
      for octet <- decimal_ip_list do
        String.to_integer(octet)
      end

    decimal_mask_numbers =
      for octet <- decimal_mask_list do
        String.to_integer(octet)
      end

    binary_ip_list =
      for octet <- decimal_ip_numbers do
        decimal_to_binary(octet, "", [128, 64, 32, 16, 8, 4, 2, 1])
      end

    binary_mask_list =
      for octet <- decimal_mask_numbers do
        decimal_to_binary(octet, "", [128, 64, 32, 16, 8, 4, 2, 1])
      end

    binary_ip_address = Enum.join(binary_ip_list)
    binary_mask_address = Enum.join(binary_mask_list)

    number_of_ones_in_mask =
      binary_mask_address
      |> String.graphemes()
      |> Enum.count(&(&1 == "1"))

    num_of_masked_octets = div(number_of_ones_in_mask, 8)
    magic_octet = num_of_masked_octets + 1
    number_of_bits_into_magic_octet = rem(number_of_ones_in_mask, 8)

    binary_ip_network_portion = String.slice(binary_ip_address, 0..(number_of_ones_in_mask - 1))
    binary_host_portion_of_ip = String.slice(binary_ip_address, (number_of_ones_in_mask - 32)..31)
    ones_for_subnet_mask = Enum.join(List.duplicate("1", number_of_ones_in_mask))

    zeroes_for_subnet_address_and_mask =
      Enum.join(List.duplicate("0", 32 - number_of_ones_in_mask))

    ones_for_broadcast_address = Enum.join(List.duplicate("1", 32 - number_of_ones_in_mask))
    binary_ip_address = binary_ip_network_portion <> binary_host_portion_of_ip
    binary_mask_address = ones_for_subnet_mask <> zeroes_for_subnet_address_and_mask
    binary_subnet_address = binary_ip_network_portion <> zeroes_for_subnet_address_and_mask
    binary_broadcast_address = binary_ip_network_portion <> ones_for_broadcast_address

    binary_ip_first_octet = String.slice(binary_ip_address, 0..7)
    binary_ip_second_octet = String.slice(binary_ip_address, 8..15)
    binary_ip_third_octet = String.slice(binary_ip_address, 16..23)
    binary_ip_fourth_octet = String.slice(binary_ip_address, 24..31)

    binary_mask_first_octet = String.slice(binary_mask_address, 0..7)
    binary_mask_second_octet = String.slice(binary_mask_address, 8..15)
    binary_mask_third_octet = String.slice(binary_mask_address, 16..23)
    binary_mask_fourth_octet = String.slice(binary_mask_address, 24..31)

    binary_subnet_first_octet = String.slice(binary_subnet_address, 0..7)
    binary_subnet_second_octet = String.slice(binary_subnet_address, 8..15)
    binary_subnet_third_octet = String.slice(binary_subnet_address, 16..23)
    binary_subnet_fourth_octet = String.slice(binary_subnet_address, 24..31)

    binary_broadcast_first_octet = String.slice(binary_broadcast_address, 0..7)
    binary_broadcast_second_octet = String.slice(binary_broadcast_address, 8..15)
    binary_broadcast_third_octet = String.slice(binary_broadcast_address, 16..23)
    binary_broadcast_fourth_octet = String.slice(binary_broadcast_address, 24..31)

    subnet_first_octet = binary_to_decimal(binary_subnet_first_octet)
    subnet_second_octet = binary_to_decimal(binary_subnet_second_octet)
    subnet_third_octet = binary_to_decimal(binary_subnet_third_octet)
    subnet_fourth_octet = binary_to_decimal(binary_subnet_fourth_octet)

    broadcast_first_octet = binary_to_decimal(binary_broadcast_first_octet)
    broadcast_second_octet = binary_to_decimal(binary_broadcast_second_octet)
    broadcast_third_octet = binary_to_decimal(binary_broadcast_third_octet)
    broadcast_fourth_octet = binary_to_decimal(binary_broadcast_fourth_octet)

    magic_octet_binary_ip_msd =
      get_magic_octet_msd(binary_ip_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_ip_lsd =
      get_magic_octet_lsd(binary_ip_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_subnet_lsd =
      get_magic_octet_lsd(binary_subnet_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_broadcast_lsd =
      get_magic_octet_lsd(binary_broadcast_address, num_of_masked_octets, number_of_ones_in_mask)

    binary_ip_as_32_bit_number = binary_to_decimal_32(binary_ip_address)
    binary_mask_as_32_bit_number = binary_to_decimal_32(binary_mask_address)
    binary_subnet_as_32_bit_number = binary_to_decimal_32(binary_subnet_address)
    binary_broadcast_as_32_bit_number = binary_to_decimal_32(binary_broadcast_address)

    case magic_octet do
      1 ->
        calc_magic_first_octet_binary_ip_msd = magic_octet_binary_ip_msd
        calc_magic_first_octet_binary_ip_lsd = magic_octet_binary_ip_lsd
        calc_binary_subnet_first_octet = nil
        calc_binary_subnet_second_octet = binary_subnet_second_octet
        calc_binary_subnet_third_octet = binary_subnet_third_octet
        calc_binary_subnet_fourth_octet = binary_subnet_fourth_octet
        calc_broadcast_first_octet = nil
        calc_broadcast_second_octet = broadcast_second_octet
        calc_broadcast_third_octet = broadcast_third_octet
        calc_broadcast_fourth_octet = broadcast_fourth_octet
        calc_binary_broadcast_first_octet = nil
        calc_binary_broadcast_second_octet = binary_broadcast_second_octet
        calc_binary_broadcast_third_octet = binary_broadcast_third_octet
        calc_binary_broadcast_fourth_octet = binary_broadcast_fourth_octet

      2 ->
        calc_magic_second_octet_binary_ip_msd = magic_octet_binary_ip_msd
        calc_magic_second_octet_binary_ip_lsd = magic_octet_binary_ip_lsd
        calc_binary_subnet_first_octet = binary_subnet_first_octet
        calc_binary_subnet_second_octet = nil
        calc_binary_subnet_third_octet = binary_subnet_third_octet
        calc_binary_subnet_fourth_octet = binary_subnet_fourth_octet
        calc_broadcast_first_octet = broadcast_first_octet
        calc_broadcast_second_octet = nil
        calc_broadcast_third_octet = broadcast_third_octet
        calc_broadcast_fourth_octet = broadcast_fourth_octet
        calc_binary_broadcast_first_octet = binary_broadcast_first_octet
        calc_binary_broadcast_second_octet = nil
        calc_binary_broadcast_third_octet = binary_broadcast_third_octet
        calc_binary_broadcast_fourth_octet = binary_broadcast_fourth_octet

      3 ->
        calc_magic_third_octet_binary_ip_msd = magic_octet_binary_ip_msd
        calc_magic_third_octet_binary_ip_lsd = magic_octet_binary_ip_lsd
        calc_binary_subnet_first_octet = binary_subnet_first_octet
        calc_binary_subnet_second_octet = binary_subnet_second_octet
        calc_binary_subnet_third_octet = nil
        calc_binary_subnet_fourth_octet = binary_subnet_fourth_octet
        calc_broadcast_first_octet = broadcast_first_octet
        calc_broadcast_second_octet = broadcast_second_octet
        calc_broadcast_third_octet = nil
        calc_broadcast_fourth_octet = broadcast_fourth_octet
        calc_binary_broadcast_first_octet = binary_broadcast_first_octet
        calc_binary_broadcast_second_octet = binary_broadcast_second_octet
        calc_binary_broadcast_third_octet = nil
        calc_binary_broadcast_fourth_octet = binary_broadcast_fourth_octet

      4 ->
        calc_magic_fourth_octet_binary_ip_msd = magic_octet_binary_ip_msd
        calc_magic_fourth_octet_binary_ip_lsd = magic_octet_binary_ip_lsd
        calc_binary_subnet_first_octet = binary_subnet_first_octet
        calc_binary_subnet_second_octet = binary_subnet_second_octet
        calc_binary_subnet_third_octet = binary_subnet_third_octet
        calc_binary_subnet_fourth_octet = nil
        calc_broadcast_first_octet = broadcast_first_octet
        calc_broadcast_second_octet = broadcast_second_octet
        calc_broadcast_third_octet = broadcast_third_octet
        calc_broadcast_fourth_octet = nil
        calc_binary_broadcast_first_octet = binary_broadcast_first_octet
        calc_binary_broadcast_second_octet = binary_broadcast_second_octet
        calc_binary_broadcast_third_octet = binary_broadcast_third_octet
        calc_binary_broadcast_fourth_octet = nil
    end

    %{
      ip_struct
      | ip_first_octet: ip_first_octet,
        ip_second_octet: ip_second_octet,
        ip_third_octet: ip_third_octet,
        ip_fourth_octet: ip_fourth_octet,
        binary_ip_first_octet: binary_ip_first_octet,
        binary_ip_second_octet: binary_ip_second_octet,
        binary_ip_third_octet: binary_ip_third_octet,
        binary_ip_fourth_octet: binary_ip_fourth_octet,
        mask_first_octet: mask_first_octet,
        mask_second_octet: mask_second_octet,
        mask_third_octet: mask_third_octet,
        mask_fourth_octet: mask_fourth_octet,
        binary_mask_first_octet: binary_mask_first_octet,
        binary_mask_second_octet: binary_mask_second_octet,
        binary_mask_third_octet: binary_mask_third_octet,
        binary_mask_fourth_octet: binary_mask_fourth_octet,
        subnet_first_octet: subnet_first_octet,
        subnet_second_octet: subnet_second_octet,
        subnet_third_octet: subnet_third_octet,
        subnet_fourth_octet: subnet_fourth_octet,
        calc_binary_subnet_first_octet: calc_binary_subnet_first_octet,
        calc_binary_subnet_second_octet: calc_binary_subnet_second_octet,
        calc_binary_subnet_third_octet: calc_binary_subnet_third_octet,
        calc_binary_subnet_fourth_octet: calc_binary_subnet_fourth_octet,
        broadcast_first_octet: broadcast_first_octet,
        broadcast_second_octet: broadcast_second_octet,
        broadcast_third_octet: broadcast_third_octet,
        broadcast_fourth_octet: broadcast_fourth_octet,
        calc_binary_broadcast_first_octet: calc_binary_broadcast_first_octet,
        calc_binary_broadcast_second_octet: calc_binary_broadcast_second_octet,
        calc_binary_broadcast_third_octet: calc_binary_broadcast_third_octet,
        calc_binary_broadcast_fourth_octet: calc_binary_broadcast_fourth_octet,
        calc_magic_first_octet_binary_ip_msd: calc_magic_first_octet_binary_ip_msd,
        calc_magic_first_octet_binary_ip_lsd: calc_magic_first_octet_binary_ip_lsd,
        calc_magic_second_octet_binary_ip_msd: calc_magic_second_octet_binary_ip_msd,
        calc_magic_second_octet_binary_ip_lsd: calc_magic_second_octet_binary_ip_lsd,
        calc_magic_third_octet_binary_ip_msd: calc_magic_third_octet_binary_ip_msd,
        calc_magic_third_octet_binary_ip_lsd: calc_magic_third_octet_binary_ip_lsd,
        calc_magic_fourth_octet_binary_ip_msd: calc_magic_fourth_octet_binary_ip_msd,
        calc_magic_fourth_octet_binary_ip_lsd: calc_magic_fourth_octet_binary_ip_lsd,
        number_of_ones_in_mask: number_of_ones_in_mask,
        binary_ip_network_portion: binary_ip_network_portion,
        ones_for_subnet_mask: ones_for_subnet_mask,
        zeroes_for_subnet_address_and_mask: zeroes_for_subnet_address_and_mask,
        binary_host_portion_of_ip: binary_host_portion_of_ip,
        ones_for_broadcast_address: ones_for_broadcast_address,
        magic_octet_subnet_lsd: magic_octet_subnet_lsd,
        magic_octet_broadcast_lsd: magic_octet_broadcast_lsd,
        binary_ip_as_32_bit_number: binary_ip_as_32_bit_number,
        binary_mask_as_32_bit_number: binary_mask_as_32_bit_number,
        binary_subnet_as_32_bit_number: binary_subnet_as_32_bit_number,
        binary_broadcast_as_32_bit_number: binary_broadcast_as_32_bit_number
    }
  end

  defp get_magic_octet_msd(bits, num_of_masked_octets, number_of_ones_in_mask) do
    magic_octet_msd = String.slice(bits, (8 * num_of_masked_octets)..(number_of_ones_in_mask - 1))
  end

  defp get_magic_octet_lsd(bits, num_of_masked_octets, number_of_ones_in_mask) do
    magic_octet_lsd =
      String.slice(bits, number_of_ones_in_mask..(8 * (num_of_masked_octets + 1) - 1))
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
    binary
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
    value
  end

  def binary_to_decimal_32(binary) do
    format_binary_32(binary)
    |> add_bits_base_2_32(
      [
        2_147_483_648,
        1_073_741_824,
        536_870_912,
        268_435_456,
        134_217_728,
        67_108_864,
        33_554_432,
        16_777_216,
        8_388_608,
        4_194_304,
        2_097_152,
        1_048_576,
        524_288,
        262_144,
        131_072,
        65536,
        32768,
        16384,
        8192,
        4096,
        2048,
        1024,
        512,
        256,
        128,
        64,
        32,
        16,
        8,
        4,
        2,
        1
      ],
      0
    )
  end

  defp format_binary_32(binary) do
    binary_list = String.graphemes(binary)
    Enum.map(binary_list, &String.to_integer/1)
  end

  defp add_bits_base_2_32([binary_head | binary_tail], [value_head | value_tail], value) do
    new_value = binary_head * value_head + value
    add_bits_base_2_32(binary_tail, value_tail, new_value)
  end

  defp add_bits_base_2_32([], [], value) do
    value
  end
end
