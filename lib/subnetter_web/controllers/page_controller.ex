defmodule SubnetterWeb.PageController do
  use SubnetterWeb, :controller
  import SubnetCalc

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def subnetter(
        conn,
        %{
          "ip" => ip,
          "mask" => mask
        } = params
      ) do
    ip_struct_after_parse = SubnetCalc.main(ip, mask)
    ip_map = Map.from_struct(ip_struct_after_parse)
    IO.inspect(ip_map, label: "*!*!*!*!*!ip_map inspect")
    render(conn, "results.html", ip_map)
  end
end
