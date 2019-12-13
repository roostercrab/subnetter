defmodule IPStruct do
  defstruct original_decimal_ip_address_list: nil,
            original_decimal_mask_list: nil,
            original_binary_ip_address_list: nil,
            original_binary_mask_list: nil,
            number_of_ones_in_mask: nil,
            magic_octet: nil,
            binary_ip_network_portion: nil,
            binary_host_portion_of_ip: nil,
            ones_for_subnet_mask: nil,
            zeroes_for_subnet_address_and_mask: nil,
            ones_for_broadcast_address: nil,
            magic_octet_ip_msd: nil,
            magic_octet_ip_lsd: nil,
            magic_octet_subnet_lsd: nil,
            magic_octet_broadcast_lsd: nil
end
