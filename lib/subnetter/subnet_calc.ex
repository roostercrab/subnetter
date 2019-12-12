defmodule SubnetFigurin do
  def main(original_ip_address, original_subnet_mask) do
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
  end

  def change_decimal_to_binary(value, binary, [head | tail]) do
    new_value = value - head

    cond do
      new_value >= 0 ->
        new_binary = "#{binary}" <> "1"
        IO.inspect(value, label: "Value")
        IO.inspect(new_value, label: "New Value")
        IO.inspect(new_binary, label: "New Binary")
        IO.inspect(tail, label: "Tail")
        change_decimal_to_binary(new_value, new_binary, tail)

      new_value < 0 ->
        new_binary = "#{binary}" <> "0"
        IO.inspect(value, label: "Value")
        IO.inspect(new_value, label: "New Value")
        IO.inspect(new_binary, label: "New Binary")
        IO.inspect(tail, label: "Tail")
        change_decimal_to_binary(value, new_binary, tail)
    end
  end

  def change_decimal_to_binary(value, binary, []) do
    IO.inspect(value, label: "VALUE")
    IO.inspect(binary, label: "BINARY")
  end



  def change_binary_to_decimal(binary) do
    format_binary(binary)
    |> combine_values([128, 64, 32, 16, 8, 4, 2, 1], 0)
  end

  defp format_binary(binary) do
    binary_list = String.graphemes(binary)
    Enum.map(binary_list, &String.to_integer/1)
  end
  
  defp combine_values([binary_head | binary_tail], [value_head | value_tail], value) do
    new_value = (binary_head * value_head) + value
    combine_values(binary_tail, value_tail, new_value)
  end
    
  defp combine_values([], [], value) do
    IO.inspect(value, label: "VALUE")
  end



end

# def change_decimal_to_binary(octet) do 
#   subtract()
# end 

# def break_down() do
#   Enum.map([128, 64, 32, 16, 8, 4, 2, 1], fn x -> (decumulation(decumulator, x))  end)
# end

# def decumulation(number_to_check, what_to_check_by) do
#     (number_to_check - what_to_check_by) > 0 ->
#       bit = 1
#       next_number = number_to_check - what_to_check_by
#     (number_to_check - what_to_check_by) < 0 ->
#       bit = 0
#       next_number = number_to_check
# end

# def check_number([128, 64, 32, 16, 8, 4, 2, 1], decumulator) do
#   check_number(tail, head - decumulator)
# end

# def check_number([128, 64, 32, 16, 8, 4, 2, 1], decumulator) do
#   check_number(tail, decumulation(head, decumulator))
# end

# def check_number([], accumulator) do
#   accumulator
# end
