defmodule TeiserverWeb.Admin.TextCallbackController do
  use CentralWeb, :controller

  alias Teiserver.{Communication}
  alias Teiserver.Communication.TextCallbackLib
  import Central.Helpers.StringHelper, only: [convert_textarea_to_array: 1]
  alias Central.Helpers.StylingHelper

  plug Bodyguard.Plug.Authorize,
    policy: Teiserver.Communication.TextCallback,
    action: {Phoenix.Controller, :action_name},
    user: {Central.Account.AuthLib, :current_user}

  plug(AssignPlug,
    site_menu_active: "admin",
    sub_menu_active: "text_callback"
  )

  plug :add_breadcrumb, name: 'Admin', url: '/admin'
  plug :add_breadcrumb, name: 'Lobby policies', url: '/admin/text_callbacks'

  @spec index(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def index(conn, params) do
    text_callbacks =
      Communication.list_text_callbacks(
        search: [
          basic_search: Map.get(params, "s", "") |> String.trim()
        ],
        order_by: "Name (A-Z)"
      )

    conn
    |> assign(:text_callbacks, text_callbacks)
    |> render("index.html")
  end

  @spec show(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    text_callback =
      Communication.get_text_callback!(id,
        joins: []
      )

    text_callback
    |> TextCallbackLib.make_favourite()
    |> insert_recently(conn)

    conn
    |> assign(:text_callback, text_callback)
    |> add_breadcrumb(name: "Show: #{text_callback.name}", url: conn.request_path)
    |> render("show.html")
  end

  @spec new(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset =
      Communication.change_text_callback(%Communication.TextCallback{
        icon: "fa-solid fa-" <> StylingHelper.random_icon(),
        colour: StylingHelper.random_colour()
      })

    conn
    |> assign(:changeset, changeset)
    |> add_breadcrumb(name: "New lobby policy", url: conn.request_path)
    |> render("new.html")
  end

  @spec create(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def create(conn, %{"text_callback" => text_callback_params}) do
    text_callback_params =
      Map.merge(text_callback_params, %{
        "triggers" =>
          (text_callback_params["triggers"] || "")
          |> String.downcase()
          |> convert_textarea_to_array
          |> Enum.sort()
      })

    case Communication.create_text_callback(text_callback_params) do
      {:ok, _text_callback} ->
        conn
        |> put_flash(:info, "Lobby policy created successfully.")
        |> redirect(to: ~p"/admin/text_callbacks/")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  @spec edit(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    text_callback = Communication.get_text_callback!(id)

    changeset = Communication.change_text_callback(text_callback)

    conn
    |> assign(:text_callback, text_callback)
    |> assign(:changeset, changeset)
    |> add_breadcrumb(name: "Edit: #{text_callback.name}", url: conn.request_path)
    |> render("edit.html")
  end

  @spec update(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "text_callback" => text_callback_params}) do
    text_callback_params =
      Map.merge(text_callback_params, %{
        "triggers" =>
          (text_callback_params["triggers"] || "")
          |> String.downcase()
          |> convert_textarea_to_array
          |> Enum.sort()
      })

    text_callback = Communication.get_text_callback!(id)

    case Communication.update_text_callback(text_callback, text_callback_params) do
      {:ok, _text_callback} ->
        conn
        |> put_flash(:info, "Lobby policy updated successfully.")
        |> redirect(to: ~p"/admin/text_callbacks")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:text_callback, text_callback)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  @spec delete(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    text_callback = Communication.get_text_callback!(id)

    text_callback
    |> TextCallbackLib.make_favourite()
    |> remove_recently(conn)

    {:ok, _text_callback} = Communication.delete_text_callback(text_callback)

    conn
    |> put_flash(:info, "Lobby policy deleted successfully.")
    |> redirect(to: ~p"/admin/text_callbacks")
  end
end
