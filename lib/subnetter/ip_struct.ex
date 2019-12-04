defmodule IPStruct do
  defstruct original_ip_address: nil,
            original_subnet_mask: nil,
            original_ip_address_list: nil,
            original_subnet_mask_list: nil,
            original_ip_binary_list: nil,
            original_mask_binary_list: nil,
            binary_subnet_address: nil,
            dotted_decimal_subnet_address: nil,
            binary_broadcast_address: nil,
            dotted_decimal_broadcast_address: nil,
            number_of_ones_in_mask: nil,
            network_portion_of_ip: nil,
            zeroes_for_subnet_address: nil,
            ones_for_broadcast_address: nil
end
