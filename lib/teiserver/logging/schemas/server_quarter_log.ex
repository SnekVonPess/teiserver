defmodule Teiserver.Logging.ServerQuarterLog do
  use CentralWeb, :schema

  @primary_key false
  schema "teiserver_server_quarter_logs" do
    field :year, :integer, primary_key: true
    field :quarter, :integer, primary_key: true
    field :date, :date
    field :data, :map
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(Map.t(), Map.t()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(year quarter date data)a)
    |> validate_required(~w(year quarter date data)a)
  end

  @spec authorize(atom, Plug.Conn.t(), Map.t()) :: boolean
  def authorize(_action, conn, _params), do: allow?(conn, "Server")
end
