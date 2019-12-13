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
    ip_struct = SubnetCalc.main(ip, mask)
    ip_map = Map.from_struct(ip_struct)
    IO.inspect(ip_map, label: "*!*!*!*!*!ip_map inspect")
    render(conn, "results.html", ip_map)
  end
end
