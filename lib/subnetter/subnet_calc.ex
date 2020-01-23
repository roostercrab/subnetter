defmodule SubnetCalc do
  def main(ip, mask) do
    ip_struct = %IPStruct{}
    decimal_ip_list = String.split(ip, ".")
    cond do
      mask == "/1" ->
        dotted_decimal_mask = "128.0.0.0"

      mask == "/2" ->
        dotted_decimal_mask = "192.0.0.0"

      mask == "/3" ->
        dotted_decimal_mask = "224.0.0.0"

      mask == "/4" ->
        dotted_decimal_mask = "240.0.0.0"

      mask == "/5" ->
        dotted_decimal_mask = "248.0.0.0"

      mask == "/6" ->
        dotted_decimal_mask = "252.0.0.0"

      mask == "/7" ->
        dotted_decimal_mask = "254.0.0.0"

      mask == "/8" ->
        dotted_decimal_mask = "255.0.0.0"

      mask == "/9" ->
        dotted_decimal_mask = "255.128.0.0"

      mask == "/10" ->
        dotted_decimal_mask = "255.192.0.0"

      mask == "/11" ->
        dotted_decimal_mask = "255.224.0.0"

      mask == "/12" ->
        dotted_decimal_mask = "255.240.0.0"

      mask == "/13" ->
        dotted_decimal_mask = "255.248.0.0"

      mask == "/14" ->
        dotted_decimal_mask = "255.252.0.0"

      mask == "/15" ->
        dotted_decimal_mask = "255.254.0.0"

      mask == "/16" ->
        dotted_decimal_mask = "255.255.0.0"

      mask == "/17" ->
        dotted_decimal_mask = "255.255.128.0"

      mask == "/18" ->
        dotted_decimal_mask = "255.255.192.0"

      mask == "/19" ->
        dotted_decimal_mask = "255.255.224.0"

      mask == "/20" ->
        dotted_decimal_mask = "255.255.240.0"

      mask == "/21" ->
        dotted_decimal_mask = "255.255.248.0"

      mask == "/22" ->
        dotted_decimal_mask = "255.255.252.0"

      mask == "/23" ->
        dotted_decimal_mask = "255.255.254.0"

      mask == "/24" ->
        dotted_decimal_mask = "255.255.255.0"

      mask == "/25" ->
        dotted_decimal_mask = "255.255.255.128"

      mask == "/26" ->
        dotted_decimal_mask = "255.255.255.192"

      mask == "/27" ->
        dotted_decimal_mask = "255.255.255.224"

      mask == "/28" ->
        dotted_decimal_mask = "255.255.255.240"

      mask == "/29" ->
        dotted_decimal_mask = "255.255.255.248"

      mask == "/30" ->
        dotted_decimal_mask = "255.255.255.252"

      mask == "/31" ->
        dotted_decimal_mask = "255.255.255.254"

      mask == "/32" ->
        dotted_decimal_mask = "255.255.255.255"

      true ->
        dotted_decimal_mask = mask
        IO.inspect(dotted_decimal_mask, label: "Dotted Decimal Mask")
    end

    decimal_mask_list = String.split(dotted_decimal_mask, ".")

    [
      ip_1st_octet,
      ip_2nd_octet,
      ip_3rd_octet,
      ip_4th_octet
    ] = decimal_ip_list

    [
      mask_1st_octet,
      mask_2nd_octet,
      mask_3rd_octet,
      mask_4th_octet
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
    binary_ip_host_portion = String.slice(binary_ip_address, (number_of_ones_in_mask - 32)..31)
    ones_for_subnet_mask = Enum.join(List.duplicate("1", number_of_ones_in_mask))

    zeroes_for_subnet_address_and_mask =
      Enum.join(List.duplicate("0", 32 - number_of_ones_in_mask))

    ones_for_broadcast_address = Enum.join(List.duplicate("1", 32 - number_of_ones_in_mask))
    binary_ip_address = binary_ip_network_portion <> binary_ip_host_portion
    binary_mask_address = ones_for_subnet_mask <> zeroes_for_subnet_address_and_mask
    binary_subnet_address = binary_ip_network_portion <> zeroes_for_subnet_address_and_mask
    binary_broadcast_address = binary_ip_network_portion <> ones_for_broadcast_address

    binary_ip_1st_octet = String.slice(binary_ip_address, 0..7)
    binary_ip_2nd_octet = String.slice(binary_ip_address, 8..15)
    binary_ip_3rd_octet = String.slice(binary_ip_address, 16..23)
    binary_ip_4th_octet = String.slice(binary_ip_address, 24..31)

    binary_mask_1st_octet = String.slice(binary_mask_address, 0..7)
    binary_mask_2nd_octet = String.slice(binary_mask_address, 8..15)
    binary_mask_3rd_octet = String.slice(binary_mask_address, 16..23)
    binary_mask_4th_octet = String.slice(binary_mask_address, 24..31)

    binary_subnet_1st_octet = String.slice(binary_subnet_address, 0..7)
    binary_subnet_2nd_octet = String.slice(binary_subnet_address, 8..15)
    binary_subnet_3rd_octet = String.slice(binary_subnet_address, 16..23)
    binary_subnet_4th_octet = String.slice(binary_subnet_address, 24..31)

    binary_broadcast_1st_octet = String.slice(binary_broadcast_address, 0..7)
    binary_broadcast_2nd_octet = String.slice(binary_broadcast_address, 8..15)
    binary_broadcast_3rd_octet = String.slice(binary_broadcast_address, 16..23)
    binary_broadcast_4th_octet = String.slice(binary_broadcast_address, 24..31)

    subnet_1st_octet = binary_to_decimal(binary_subnet_1st_octet)
    subnet_2nd_octet = binary_to_decimal(binary_subnet_2nd_octet)
    subnet_3rd_octet = binary_to_decimal(binary_subnet_3rd_octet)
    subnet_4th_octet = binary_to_decimal(binary_subnet_4th_octet)

    broadcast_1st_octet = binary_to_decimal(binary_broadcast_1st_octet)
    broadcast_2nd_octet = binary_to_decimal(binary_broadcast_2nd_octet)
    broadcast_3rd_octet = binary_to_decimal(binary_broadcast_3rd_octet)
    broadcast_4th_octet = binary_to_decimal(binary_broadcast_4th_octet)

    magic_octet_binary_ip_msd =
      get_magic_octet_msd(binary_ip_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_ip_lsd =
      get_magic_octet_lsd(binary_ip_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_mask_msd =
      get_magic_octet_msd(binary_mask_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_mask_lsd =
      get_magic_octet_lsd(binary_mask_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_subnet_msd =
      get_magic_octet_msd(binary_subnet_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_subnet_lsd =
      get_magic_octet_lsd(binary_subnet_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_broadcast_msd =
      get_magic_octet_msd(binary_broadcast_address, num_of_masked_octets, number_of_ones_in_mask)

    magic_octet_binary_broadcast_lsd =
      get_magic_octet_lsd(binary_broadcast_address, num_of_masked_octets, number_of_ones_in_mask)

    binary_ip_as_32_bit_number = binary_to_decimal_32(binary_ip_address)
    binary_mask_as_32_bit_number = binary_to_decimal_32(binary_mask_address)
    binary_subnet_as_32_bit_number = binary_to_decimal_32(binary_subnet_address)
    binary_broadcast_as_32_bit_number = binary_to_decimal_32(binary_broadcast_address)

    ip_struct_after_parse =
      parse_magic_octet(
        binary_broadcast_1st_octet,
        binary_broadcast_2nd_octet,
        binary_broadcast_3rd_octet,
        binary_broadcast_4th_octet,
        binary_ip_1st_octet,
        binary_ip_2nd_octet,
        binary_ip_3rd_octet,
        binary_ip_4th_octet,
        binary_mask_1st_octet,
        binary_mask_2nd_octet,
        binary_mask_3rd_octet,
        binary_mask_4th_octet,
        binary_subnet_1st_octet,
        binary_subnet_2nd_octet,
        binary_subnet_3rd_octet,
        binary_subnet_4th_octet,
        ip_struct,
        magic_octet_binary_ip_lsd,
        magic_octet_binary_ip_msd,
        magic_octet_binary_mask_lsd,
        magic_octet_binary_mask_msd,
        magic_octet_binary_subnet_lsd,
        magic_octet_binary_subnet_msd,
        magic_octet_binary_broadcast_lsd,
        magic_octet_binary_broadcast_msd,
        magic_octet
      )

    %{
      ip_struct_after_parse
      | ip_1st_octet: ip_1st_octet,
        ip_2nd_octet: ip_2nd_octet,
        ip_3rd_octet: ip_3rd_octet,
        ip_4th_octet: ip_4th_octet,
        mask_1st_octet: mask_1st_octet,
        mask_2nd_octet: mask_2nd_octet,
        mask_3rd_octet: mask_3rd_octet,
        mask_4th_octet: mask_4th_octet,
        subnet_1st_octet: subnet_1st_octet,
        subnet_2nd_octet: subnet_2nd_octet,
        subnet_3rd_octet: subnet_3rd_octet,
        subnet_4th_octet: subnet_4th_octet,
        broadcast_1st_octet: broadcast_1st_octet,
        broadcast_2nd_octet: broadcast_2nd_octet,
        broadcast_3rd_octet: broadcast_3rd_octet,
        broadcast_4th_octet: broadcast_4th_octet,
        number_of_ones_in_mask: number_of_ones_in_mask,
        binary_ip_network_portion: binary_ip_network_portion,
        ones_for_subnet_mask: ones_for_subnet_mask,
        zeroes_for_subnet_address_and_mask: zeroes_for_subnet_address_and_mask,
        binary_ip_host_portion: binary_ip_host_portion,
        ones_for_broadcast_address: ones_for_broadcast_address,
        binary_ip_as_32_bit_number: binary_ip_as_32_bit_number,
        binary_mask_as_32_bit_number: binary_mask_as_32_bit_number,
        binary_subnet_as_32_bit_number: binary_subnet_as_32_bit_number,
        binary_broadcast_as_32_bit_number: binary_broadcast_as_32_bit_number
    }
  end

  def parse_magic_octet(
        binary_broadcast_1st_octet,
        binary_broadcast_2nd_octet,
        binary_broadcast_3rd_octet,
        binary_broadcast_4th_octet,
        binary_ip_1st_octet,
        binary_ip_2nd_octet,
        binary_ip_3rd_octet,
        binary_ip_4th_octet,
        binary_mask_1st_octet,
        binary_mask_2nd_octet,
        binary_mask_3rd_octet,
        binary_mask_4th_octet,
        binary_subnet_1st_octet,
        binary_subnet_2nd_octet,
        binary_subnet_3rd_octet,
        binary_subnet_4th_octet,
        ip_struct,
        magic_octet_binary_ip_lsd,
        magic_octet_binary_ip_msd,
        magic_octet_binary_mask_lsd,
        magic_octet_binary_mask_msd,
        magic_octet_binary_subnet_lsd,
        magic_octet_binary_subnet_msd,
        magic_octet_binary_broadcast_lsd,
        magic_octet_binary_broadcast_msd,
        magic_octet
      ) do
    case magic_octet do
      1 ->
        IO.puts("******** Made it to 1")

        ip_struct = %{
          ip_struct
          | calc_magic_1st_octet_binary_ip_msd: magic_octet_binary_ip_msd,
            calc_magic_1st_octet_binary_ip_lsd: magic_octet_binary_ip_lsd,
            calc_magic_1st_octet_binary_mask_msd: magic_octet_binary_mask_msd,
            calc_magic_1st_octet_binary_mask_lsd: magic_octet_binary_mask_lsd,
            calc_magic_1st_octet_binary_subnet_msd: magic_octet_binary_subnet_msd,
            calc_magic_1st_octet_binary_subnet_lsd: magic_octet_binary_subnet_lsd,
            calc_magic_1st_octet_binary_broadcast_msd: magic_octet_binary_broadcast_msd,
            calc_magic_1st_octet_binary_broadcast_lsd: magic_octet_binary_broadcast_lsd,
            calc_binary_ip_2nd_octet: binary_ip_2nd_octet,
            calc_binary_ip_3rd_octet: binary_ip_3rd_octet,
            calc_binary_ip_4th_octet: binary_ip_4th_octet,
            calc_binary_mask_2nd_octet: binary_mask_2nd_octet,
            calc_binary_mask_3rd_octet: binary_mask_3rd_octet,
            calc_binary_mask_4th_octet: binary_mask_4th_octet,
            calc_binary_subnet_2nd_octet: binary_subnet_2nd_octet,
            calc_binary_subnet_3rd_octet: binary_subnet_3rd_octet,
            calc_binary_subnet_4th_octet: binary_subnet_4th_octet,
            calc_binary_broadcast_2nd_octet: binary_broadcast_2nd_octet,
            calc_binary_broadcast_3rd_octet: binary_broadcast_3rd_octet,
            calc_binary_broadcast_4th_octet: binary_broadcast_4th_octet,
            first_ip_msd_color: "ip",
            first_ip_lsd_color: "host",
            second_ip_msd_color: "host",
            second_ip_lsd_color: "host",
            third_ip_msd_color: "host",
            third_ip_lsd_color: "host",
            fourth_ip_msd_color: "host",
            fourth_ip_lsd_color: "host",
            first_mask_msd_color: "mask_ones",
            first_mask_lsd_color: "mask_zeroes",
            second_mask_msd_color: "mask_zeroes",
            second_mask_lsd_color: "mask_zeroes",
            third_mask_msd_color: "mask_zeroes",
            third_mask_lsd_color: "mask_zeroes",
            fourth_mask_msd_color: "mask_zeroes",
            fourth_mask_lsd_color: "mask_zeroes",
            first_subnet_msd_color: "ip",
            first_subnet_lsd_color: "subnet",
            second_subnet_msd_color: "subnet",
            second_subnet_lsd_color: "subnet",
            third_subnet_msd_color: "subnet",
            third_subnet_lsd_color: "subnet",
            fourth_subnet_msd_color: "subnet",
            fourth_subnet_lsd_color: "subnet",
            first_broadcast_msd_color: "ip",
            first_broadcast_lsd_color: "broadcast",
            second_broadcast_msd_color: "broadcast",
            second_broadcast_lsd_color: "broadcast",
            third_broadcast_msd_color: "broadcast",
            third_broadcast_lsd_color: "broadcast",
            fourth_broadcast_msd_color: "broadcast",
            fourth_broadcast_lsd_color: "broadcast"
        }

        ip_struct

      2 ->
        IO.puts("******** Made it to 2")

        ip_struct = %{
          ip_struct
          | calc_magic_2nd_octet_binary_ip_msd: magic_octet_binary_ip_msd,
            calc_magic_2nd_octet_binary_ip_lsd: magic_octet_binary_ip_lsd,
            calc_magic_2nd_octet_binary_mask_msd: magic_octet_binary_mask_msd,
            calc_magic_2nd_octet_binary_mask_lsd: magic_octet_binary_mask_lsd,
            calc_magic_2nd_octet_binary_subnet_msd: magic_octet_binary_subnet_msd,
            calc_magic_2nd_octet_binary_subnet_lsd: magic_octet_binary_subnet_lsd,
            calc_magic_2nd_octet_binary_broadcast_msd: magic_octet_binary_broadcast_msd,
            calc_magic_2nd_octet_binary_broadcast_lsd: magic_octet_binary_broadcast_lsd,
            calc_binary_ip_1st_octet: binary_ip_1st_octet,
            calc_binary_ip_3rd_octet: binary_ip_3rd_octet,
            calc_binary_ip_4th_octet: binary_ip_4th_octet,
            calc_binary_mask_1st_octet: binary_mask_1st_octet,
            calc_binary_mask_3rd_octet: binary_mask_3rd_octet,
            calc_binary_mask_4th_octet: binary_mask_4th_octet,
            calc_binary_subnet_1st_octet: binary_subnet_1st_octet,
            calc_binary_subnet_3rd_octet: binary_subnet_3rd_octet,
            calc_binary_subnet_4th_octet: binary_subnet_4th_octet,
            calc_binary_broadcast_1st_octet: binary_broadcast_1st_octet,
            calc_binary_broadcast_3rd_octet: binary_broadcast_3rd_octet,
            calc_binary_broadcast_4th_octet: binary_broadcast_4th_octet,
            first_ip_msd_color: "ip",
            first_ip_lsd_color: "ip",
            second_ip_msd_color: "ip",
            second_ip_lsd_color: "host",
            third_ip_msd_color: "host",
            third_ip_lsd_color: "host",
            fourth_ip_msd_color: "host",
            fourth_ip_lsd_color: "host",
            first_mask_msd_color: "mask_ones",
            first_mask_lsd_color: "mask_ones",
            second_mask_msd_color: "mask_ones",
            second_mask_lsd_color: "mask_zeroes",
            third_mask_msd_color: "mask_zeroes",
            third_mask_lsd_color: "mask_zeroes",
            fourth_mask_msd_color: "mask_zeroes",
            fourth_mask_lsd_color: "mask_zeroes",
            first_subnet_msd_color: "ip",
            first_subnet_lsd_color: "ip",
            second_subnet_msd_color: "ip",
            second_subnet_lsd_color: "subnet",
            third_subnet_msd_color: "subnet",
            third_subnet_lsd_color: "subnet",
            fourth_subnet_msd_color: "subnet",
            fourth_subnet_lsd_color: "subnet",
            first_broadcast_msd_color: "ip",
            first_broadcast_lsd_color: "ip",
            second_broadcast_msd_color: "ip",
            second_broadcast_lsd_color: "broadcast",
            third_broadcast_msd_color: "broadcast",
            third_broadcast_lsd_color: "broadcast",
            fourth_broadcast_msd_color: "broadcast",
            fourth_broadcast_lsd_color: "broadcast"
        }

        ip_struct

      3 ->
        IO.puts("******** Made it to 3")

        ip_struct = %{
          ip_struct
          | calc_magic_3rd_octet_binary_ip_msd: magic_octet_binary_ip_msd,
            calc_magic_3rd_octet_binary_ip_lsd: magic_octet_binary_ip_lsd,
            calc_magic_3rd_octet_binary_mask_msd: magic_octet_binary_mask_msd,
            calc_magic_3rd_octet_binary_mask_lsd: magic_octet_binary_mask_lsd,
            calc_magic_3rd_octet_binary_subnet_msd: magic_octet_binary_subnet_msd,
            calc_magic_3rd_octet_binary_subnet_lsd: magic_octet_binary_subnet_lsd,
            calc_magic_3rd_octet_binary_broadcast_msd: magic_octet_binary_broadcast_msd,
            calc_magic_3rd_octet_binary_broadcast_lsd: magic_octet_binary_broadcast_lsd,
            calc_binary_ip_1st_octet: binary_ip_1st_octet,
            calc_binary_ip_2nd_octet: binary_ip_2nd_octet,
            calc_binary_ip_4th_octet: binary_ip_4th_octet,
            calc_binary_mask_1st_octet: binary_mask_1st_octet,
            calc_binary_mask_2nd_octet: binary_mask_2nd_octet,
            calc_binary_mask_4th_octet: binary_mask_4th_octet,
            calc_binary_subnet_1st_octet: binary_subnet_1st_octet,
            calc_binary_subnet_2nd_octet: binary_subnet_2nd_octet,
            calc_binary_subnet_4th_octet: binary_subnet_4th_octet,
            calc_binary_broadcast_1st_octet: binary_broadcast_1st_octet,
            calc_binary_broadcast_2nd_octet: binary_broadcast_2nd_octet,
            calc_binary_broadcast_4th_octet: binary_broadcast_4th_octet,
            first_ip_msd_color: "ip",
            first_ip_lsd_color: "ip",
            second_ip_msd_color: "ip",
            second_ip_lsd_color: "ip",
            third_ip_msd_color: "ip",
            third_ip_lsd_color: "host",
            fourth_ip_msd_color: "host",
            fourth_ip_lsd_color: "host",
            first_mask_msd_color: "mask_ones",
            first_mask_lsd_color: "mask_ones",
            second_mask_msd_color: "mask_ones",
            second_mask_lsd_color: "mask_ones",
            third_mask_msd_color: "mask_ones",
            third_mask_lsd_color: "mask_zeroes",
            fourth_mask_msd_color: "mask_zeroes",
            fourth_mask_lsd_color: "mask_zeroes",
            first_subnet_msd_color: "ip",
            first_subnet_lsd_color: "ip",
            second_subnet_msd_color: "ip",
            second_subnet_lsd_color: "ip",
            third_subnet_msd_color: "ip",
            third_subnet_lsd_color: "subnet",
            fourth_subnet_msd_color: "subnet",
            fourth_subnet_lsd_color: "subnet",
            first_broadcast_msd_color: "ip",
            first_broadcast_lsd_color: "ip",
            second_broadcast_msd_color: "ip",
            second_broadcast_lsd_color: "ip",
            third_broadcast_msd_color: "ip",
            third_broadcast_lsd_color: "broadcast",
            fourth_broadcast_msd_color: "broadcast",
            fourth_broadcast_lsd_color: "broadcast"
        }

        ip_struct

      4 ->
        IO.puts("******** Made it to 4")

        ip_struct = %{
          ip_struct
          | calc_magic_4th_octet_binary_ip_msd: magic_octet_binary_ip_msd,
            calc_magic_4th_octet_binary_ip_lsd: magic_octet_binary_ip_lsd,
            calc_magic_4th_octet_binary_mask_msd: magic_octet_binary_mask_msd,
            calc_magic_4th_octet_binary_mask_lsd: magic_octet_binary_mask_lsd,
            calc_magic_4th_octet_binary_subnet_msd: magic_octet_binary_subnet_msd,
            calc_magic_4th_octet_binary_subnet_lsd: magic_octet_binary_subnet_lsd,
            calc_magic_4th_octet_binary_broadcast_msd: magic_octet_binary_broadcast_msd,
            calc_magic_4th_octet_binary_broadcast_lsd: magic_octet_binary_broadcast_lsd,
            calc_binary_ip_1st_octet: binary_ip_1st_octet,
            calc_binary_ip_2nd_octet: binary_ip_2nd_octet,
            calc_binary_ip_3rd_octet: binary_ip_3rd_octet,
            calc_binary_mask_1st_octet: binary_mask_1st_octet,
            calc_binary_mask_2nd_octet: binary_mask_2nd_octet,
            calc_binary_mask_3rd_octet: binary_mask_3rd_octet,
            calc_binary_subnet_1st_octet: binary_subnet_1st_octet,
            calc_binary_subnet_2nd_octet: binary_subnet_2nd_octet,
            calc_binary_subnet_3rd_octet: binary_subnet_3rd_octet,
            calc_binary_broadcast_1st_octet: binary_broadcast_1st_octet,
            calc_binary_broadcast_2nd_octet: binary_broadcast_2nd_octet,
            calc_binary_broadcast_3rd_octet: binary_broadcast_3rd_octet,
            first_ip_msd_color: "ip",
            first_ip_lsd_color: "ip",
            second_ip_msd_color: "ip",
            second_ip_lsd_color: "ip",
            third_ip_msd_color: "ip",
            third_ip_lsd_color: "ip",
            fourth_ip_msd_color: "ip",
            fourth_ip_lsd_color: "host",
            first_mask_msd_color: "mask_ones",
            first_mask_lsd_color: "mask_ones",
            second_mask_msd_color: "mask_ones",
            second_mask_lsd_color: "mask_ones",
            third_mask_msd_color: "mask_ones",
            third_mask_lsd_color: "mask_ones",
            fourth_mask_msd_color: "mask_ones",
            fourth_mask_lsd_color: "mask_zeroes",
            first_subnet_msd_color: "ip",
            first_subnet_lsd_color: "ip",
            second_subnet_msd_color: "ip",
            second_subnet_lsd_color: "ip",
            third_subnet_msd_color: "ip",
            third_subnet_lsd_color: "ip",
            fourth_subnet_msd_color: "ip",
            fourth_subnet_lsd_color: "subnet",
            first_broadcast_msd_color: "ip",
            first_broadcast_lsd_color: "ip",
            second_broadcast_msd_color: "ip",
            second_broadcast_lsd_color: "ip",
            third_broadcast_msd_color: "ip",
            third_broadcast_lsd_color: "ip",
            fourth_broadcast_msd_color: "ip",
            fourth_broadcast_lsd_color: "broadcast"
        }

        ip_struct
    end
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
