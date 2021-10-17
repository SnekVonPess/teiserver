defmodule Teiserver.Telemetry.TelemetryDayLogLib do
  use CentralWeb, :library

  alias Teiserver.Telemetry.TelemetryDayLog

  @spec colours :: {String.t(), String.t(), String.t()}
  def colours(), do: Central.Helpers.StylingHelper.colours(:warning)

  @spec icon() :: String.t()
  def icon(), do: "far fa-monitor-heart-rate"

  @spec get_telemetry_day_logs :: Ecto.Query.t()
  def get_telemetry_day_logs() do
    from(logs in TelemetryDayLog)
  end

  @spec search(Ecto.Query.t(), map | nil) :: Ecto.Query.t()
  def search(query, nil), do: query

  def search(query, params) do
    params
    |> Enum.reduce(query, fn {key, value}, query_acc ->
      _search(query_acc, key, value)
    end)
  end

  @spec _search(Ecto.Query.t(), atom, any) :: Ecto.Query.t()
  def _search(query, _, ""), do: query
  def _search(query, _, nil), do: query

  def _search(query, :date, date) do
    from logs in query,
      where: logs.date == ^date
  end

  def _search(query, :start_date, date) do
    from logs in query,
      where: logs.date >= ^date
  end

  def _search(query, :end_date, date) do
    from logs in query,
      where: logs.date <= ^date
  end

  @spec order_by(Ecto.Query.t(), String.t() | nil) :: Ecto.Query.t()
  def order_by(query, nil), do: query

  def order_by(query, "Newest first") do
    from logs in query,
      order_by: [desc: logs.date]
  end

  def order_by(query, "Oldest first") do
    from logs in query,
      order_by: [asc: logs.date]
  end
end
