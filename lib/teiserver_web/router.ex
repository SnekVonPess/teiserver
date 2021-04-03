defmodule TeiserverWeb.Router do
  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro teiserver_routes() do
    quote do
      scope "/teiserver", TeiserverWeb.Lobby, as: :ts_lobby do
        pipe_through([:browser, :admin_layout, :protected])

        get("/", GeneralController, :index)
        get("/accimp", GeneralController, :accimp)
      end

      # ts_account_X_path
      scope "/teiserver/account", TeiserverWeb.Account, as: :ts_account do
        pipe_through([:browser, :admin_layout, :protected])

        get("/relationships", RelationshipsController, :index)
        post("/relationships/find/", RelationshipsController, :find)
        post("/relationships/create/:action/:target", RelationshipsController, :create)
        put("/relationships/update/:action/:target", RelationshipsController, :update)
        delete("/relationships/delete/:action/:target", RelationshipsController, :delete)

        resources("/preferences", PreferencesController, only: [:index, :edit, :update, :new, :create])

        get("/", GeneralController, :index)
      end

      # ts_clans_X_path
      scope "/teiserver/clans", TeiserverWeb.Clans, as: :ts_clans do
        pipe_through([:browser, :admin_layout, :protected])

        get("/", ClanController, :index)
        get("/:name", ClanController, :show)
      end

      scope "/teiserver", TeiserverWeb.BattleLive, as: :ts do
        pipe_through([:browser, :admin_layout, :protected])

        live("/battle", Index, :index)
        live("/battle/:id", Show, :show)
      end

      scope "/teiserver/admin", TeiserverWeb.ClientLive, as: :ts_admin do
        pipe_through([:browser, :admin_layout, :protected])

        live("/client", Index, :index)
        live("/client/:id", Show, :show)
      end

      scope "/teiserver/admin", TeiserverWeb.Admin, as: :ts_admin do
        pipe_through([:browser, :admin_layout, :protected])

        get("/", GeneralController, :index)

        resources("/clans", ClanController)

        post("/user/reset_password/:id", UserController, :reset_password)
        put("/user/action/:id/:action", UserController, :perform_action)
        get("/user/reports/:id/respond", UserController, :respond_form)
        put("/user/reports/:id/respond", UserController, :respond_post)
        resources("/user", UserController)
      end
    end
  end
end
