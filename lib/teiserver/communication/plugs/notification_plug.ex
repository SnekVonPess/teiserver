defmodule Teiserver.Communication.NotificationPlug do
  @moduledoc false
  import Plug.Conn
  alias Teiserver.Communication

  def init(_opts) do
    # %{}
  end

  def call(%{user_id: nil} = conn, _) do
    conn
    |> assign(:user_notifications, [])
    |> assign(:user_notifications_unread_count, 0)
  end

  def call(conn, _ops) do
    if conn.params["anid"] do
      Communication.mark_notification_as_read(conn.assigns[:current_user].id, conn.params["anid"])
    end

    assign_notifications(conn, conn.assigns[:current_user])
  end

  def live_call(socket) do
    notifications =
      socket.assigns.current_user.id
      |> Communication.list_user_notifications(:unread)

    unread_count =
      notifications
      |> Enum.count(fn n ->
        not n.read
      end)

    socket
    |> Phoenix.LiveView.Utils.assign(:user_notifications, notifications)
    |> Phoenix.LiveView.Utils.assign(:user_notifications_unread_count, unread_count)
  end

  defp assign_notifications(conn, nil) do
    conn
    |> assign(:user_notifications, [])
  end

  defp assign_notifications(conn, the_user) do
    notifications =
      the_user.id
      |> Communication.list_user_notifications(:unread)

    unread_count =
      notifications
      |> Enum.count(fn n ->
        not n.read
      end)

    conn
    |> assign(:user_notifications, notifications)
    |> assign(:user_notifications_unread_count, unread_count)
  end

  def on_mount(:load_notifications, _params, _session, socket) do
    notifications =
      socket.assigns.current_user.id
      |> Communication.list_user_notifications(:unread)

    unread_count =
      notifications
      |> Enum.count(fn n ->
        not n.read
      end)

    {:cont, socket
    |> Phoenix.Component.assign(:user_notifications, notifications)
    |> Phoenix.Component.assign(:user_notifications_unread_count, unread_count)}
  end
end
