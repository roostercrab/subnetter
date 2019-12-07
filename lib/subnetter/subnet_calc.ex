defmodule SubnetCalc do
  @moduledoc """
  Documentation for Subnetter.
  """
  def main(original_ip_address, original_subnet_mask) do
    break_up_dotted_decimal(original_ip_address, original_subnet_mask, ip_struct = %IPStruct{})
    |> convert_decimal_to_binary
    |> measure_network_range
  end

  def break_up_dotted_decimal(original_ip_address, original_subnet_mask, ip_struct = %IPStruct{}) do
    original_ip_address_list = String.split(original_ip_address, ".")
    original_subnet_mask_list = String.split(original_subnet_mask, ".")

    [
      original_ip_address_first_octet,
      original_ip_address_second_octet,
      original_ip_address_third_octet,
      original_ip_address_fourth_octet
    ] = original_ip_address_list

    [
      original_subnet_mask_first_octet,
      original_subnet_mask_second_octet,
      original_subnet_mask_third_octet,
      original_subnet_mask_fourth_octet
    ] = original_subnet_mask_list

    %{
      ip_struct
      | original_ip_address: original_ip_address,
        original_ip_address_list: original_ip_address_list,
        original_ip_address_first_octet: original_ip_address_first_octet,
        original_ip_address_second_octet: original_ip_address_second_octet,
        original_ip_address_third_octet: original_ip_address_third_octet,
        original_ip_address_fourth_octet: original_ip_address_fourth_octet,
        original_subnet_mask: original_subnet_mask,
        original_subnet_mask_list: original_subnet_mask_list,
        original_subnet_mask_first_octet: original_subnet_mask_first_octet,
        original_subnet_mask_second_octet: original_subnet_mask_second_octet,
        original_subnet_mask_third_octet: original_subnet_mask_third_octet,
        original_subnet_mask_fourth_octet: original_subnet_mask_fourth_octet
    }
  end

  def convert_decimal_to_binary(ip_struct = %IPStruct{}) do
    original_ip_integer_list =
      for octet <- ip_struct.original_ip_address_list do
        String.to_integer(octet, 10)
      end

    original_ip_binary_list_maybe_not_32_bits =
      for octet <- original_ip_integer_list do
        Integer.to_string(octet, 2)
      end

    original_ip_binary_list = ensure_8_bit_length(original_ip_binary_list_maybe_not_32_bits)

    [
      original_ip_binary_first_octet,
      original_ip_binary_second_octet,
      original_ip_binary_third_octet,
      original_ip_binary_fourth_octet
    ] = original_ip_binary_list

    original_mask_integer_list =
      for octet <- ip_struct.original_subnet_mask_list do
        String.to_integer(octet, 10)
      end

    original_mask_binary_list_maybe_not_32_bits =
      for octet <- original_mask_integer_list do
        Integer.to_string(octet, 2)
      end

    original_mask_binary_list = ensure_8_bit_length(original_mask_binary_list_maybe_not_32_bits)

    [
      original_mask_binary_first_octet,
      original_mask_binary_second_octet,
      original_mask_binary_third_octet,
      original_mask_binary_fourth_octet
    ] = original_mask_binary_list

    %{
      ip_struct
      | original_ip_binary_list: original_ip_binary_list,
        original_ip_binary_first_octet: original_ip_binary_first_octet,
        original_ip_binary_second_octet: original_ip_binary_second_octet,
        original_ip_binary_third_octet: original_ip_binary_third_octet,
        original_ip_binary_fourth_octet: original_ip_binary_fourth_octet,
        original_mask_binary_list: original_mask_binary_list,
        original_mask_binary_first_octet: original_mask_binary_first_octet,
        original_mask_binary_second_octet: original_mask_binary_second_octet,
        original_mask_binary_third_octet: original_mask_binary_third_octet,
        original_mask_binary_fourth_octet: original_mask_binary_fourth_octet
    }
  end

  defp ensure_8_bit_length(binary_list) do
    for octet <- binary_list do
      number_of_bits = String.length(octet)
      needed_zeroes = 8 - number_of_bits

      cond do
        needed_zeroes == 0 ->
          octet

        needed_zeroes >= 1 ->
          zeroes = List.duplicate("0", needed_zeroes)
          "#{zeroes ++ octet}"
      end
    end
  end

  def measure_network_range(ip_struct = %IPStruct{}) do
    [
      first_ip_octet_binary,
      second_ip_octet_binary,
      third_ip_octet_binary,
      fourth_ip_octet_binary
    ] = ip_struct.original_ip_binary_list

    [
      first_mask_octet_binary,
      second_mask_octet_binary,
      third_mask_octet_binary,
      fourth_mask_octet_binary
    ] = ip_struct.original_mask_binary_list

    combined_bin_ip =
      "#{first_ip_octet_binary}#{second_ip_octet_binary}#{third_ip_octet_binary}#{
        fourth_ip_octet_binary
      }"

    combined_bin_mask =
      "#{first_mask_octet_binary}#{second_mask_octet_binary}#{third_mask_octet_binary}#{
        fourth_mask_octet_binary
      }"

    number_of_ones_in_mask =
      combined_bin_mask
      |> String.graphemes()
      |> Enum.count(&(&1 == "1"))

    magic_octet = div(number_of_ones_in_mask, 8)
    number_of_bits_into_octet = rem(number_of_ones_in_mask, 8)

    bin_network_portion_of_ip = String.slice(combined_bin_ip, 0..(number_of_ones_in_mask - 1))
    bin_host_portion_of_ip = String.slice(combined_bin_ip, ((number_of_ones_in_mask - 32)..31))
    zeroes_for_subnet_address_and_mask = List.duplicate("0", 32 - number_of_ones_in_mask)
    ones_for_broadcast_address = List.duplicate("1", 32 - number_of_ones_in_mask)
    ones_for_subnet_mask = List.duplicate("1", number_of_ones_in_mask)

    bin_str_network_portion_of_ip = "#{bin_network_portion_of_ip}"
    bin_str_host_portion_of_ip = "#{bin_host_portion_of_ip}"

    binary_subnet_address = "#{bin_network_portion_of_ip}#{zeroes_for_subnet_address_and_mask}"
    binary_subnet_address_list = binary_string_to_octet(binary_subnet_address)

    binary_broadcast_address = "#{bin_network_portion_of_ip}#{ones_for_broadcast_address}"
    binary_broadcast_address_list = binary_string_to_octet(binary_broadcast_address)

    [
      binary_subnet_address_first_octet,
      binary_subnet_address_second_octet,
      binary_subnet_address_third_octet,
      binary_subnet_address_fourth_octet
    ] = binary_subnet_address_list

    [
      binary_broadcast_address_first_octet,
      binary_broadcast_address_second_octet,
      binary_broadcast_address_third_octet,
      binary_broadcast_address_fourth_octet
    ] = binary_broadcast_address_list

    dotted_decimal_subnet_address_list = binary_string_to_dotted_decimal(binary_subnet_address)

    dotted_decimal_broadcast_address_list =
      binary_string_to_dotted_decimal(binary_broadcast_address)

    [
      dotted_decimal_subnet_address_first_octet,
      dotted_decimal_subnet_address_second_octet,
      dotted_decimal_subnet_address_third_octet,
      dotted_decimal_subnet_address_fourth_octet
    ] = dotted_decimal_subnet_address_list

    dotted_decimal_subnet_address =
      "#{dotted_decimal_subnet_address_first_octet}.#{dotted_decimal_subnet_address_second_octet}.#{
        dotted_decimal_subnet_address_third_octet
      }.#{dotted_decimal_subnet_address_fourth_octet}"

    [
      dotted_decimal_broadcast_address_first_octet,
      dotted_decimal_broadcast_address_second_octet,
      dotted_decimal_broadcast_address_third_octet,
      dotted_decimal_broadcast_address_fourth_octet
    ] = dotted_decimal_broadcast_address_list

    dotted_decimal_broadcast_address =
      "#{dotted_decimal_broadcast_address_first_octet}.#{
        dotted_decimal_broadcast_address_second_octet
      }.#{dotted_decimal_broadcast_address_third_octet}.#{
        dotted_decimal_broadcast_address_fourth_octet
      }"

    %{
      ip_struct
      | binary_subnet_address: binary_subnet_address,
        binary_subnet_address_list: binary_subnet_address_list,
        binary_subnet_address_first_octet: binary_subnet_address_first_octet,
        binary_subnet_address_second_octet: binary_subnet_address_second_octet,
        binary_subnet_address_third_octet: binary_subnet_address_third_octet,
        binary_subnet_address_fourth_octet: binary_subnet_address_fourth_octet,
        dotted_decimal_subnet_address: dotted_decimal_subnet_address,
        dotted_decimal_subnet_address_list: dotted_decimal_subnet_address,
        dotted_decimal_subnet_address_first_octet: dotted_decimal_subnet_address_first_octet,
        dotted_decimal_subnet_address_second_octet: dotted_decimal_subnet_address_second_octet,
        dotted_decimal_subnet_address_third_octet: dotted_decimal_subnet_address_third_octet,
        dotted_decimal_subnet_address_fourth_octet: dotted_decimal_subnet_address_fourth_octet,
        binary_broadcast_address: binary_broadcast_address,
        binary_broadcast_address_list: binary_broadcast_address_list,
        binary_broadcast_address_first_octet: binary_broadcast_address_first_octet,
        binary_broadcast_address_second_octet: binary_broadcast_address_second_octet,
        binary_broadcast_address_third_octet: binary_broadcast_address_third_octet,
        binary_broadcast_address_fourth_octet: binary_broadcast_address_fourth_octet,
        dotted_decimal_broadcast_address: dotted_decimal_broadcast_address,
        dotted_decimal_broadcast_address_list: dotted_decimal_broadcast_address,
        dotted_decimal_broadcast_address_first_octet:
          dotted_decimal_broadcast_address_first_octet,
        dotted_decimal_broadcast_address_second_octet:
          dotted_decimal_broadcast_address_second_octet,
        dotted_decimal_broadcast_address_third_octet:
          dotted_decimal_broadcast_address_third_octet,
        dotted_decimal_broadcast_address_fourth_octet:
          dotted_decimal_broadcast_address_fourth_octet,
        number_of_ones_in_mask: number_of_ones_in_mask,
        magic_octet: magic_octet,
        number_of_bits_into_octet: number_of_bits_into_octet,
        bin_network_portion_of_ip: bin_network_portion_of_ip,
        bin_str_network_portion_of_ip: bin_str_network_portion_of_ip,
        bin_str_host_portion_of_ip: bin_str_host_portion_of_ip,
        bin_host_portion_of_ip: bin_host_portion_of_ip,
        ones_for_subnet_mask: ones_for_subnet_mask,
        zeroes_for_subnet_address_and_mask: zeroes_for_subnet_address_and_mask,
        ones_for_broadcast_address: ones_for_broadcast_address
    }
  end

  defp binary_string_to_octet(binary_string) do
    for <<chunk::binary-size(8) <- binary_string>> do
      chunk
    end
  end

  defp binary_string_to_dotted_decimal(binary_string) do
    for <<chunk::binary-size(8) <- binary_string>> do
      octet = String.to_integer(chunk, 2)
      Integer.to_string(octet)
    end
  end
end
