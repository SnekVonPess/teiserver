defmodule Teiserver.TestData do
  # Dummy module to create fake data until this is hooked up to
  # an actual data store
  alias Teiserver.User
  alias Teiserver.Client
  alias Teiserver.Battle

  def create_users do
    ConCache.insert_new(:lists, :users, [])
    [
      %{
        name: "ChanServ",
        country: "GB",
        lobbyid: "LuaLobby Chobby",
        friends: [],
        friend_requests: []
      },
      %{
        name: "[teh]cluster1[03]",
        country: "GB",
        lobbyid: "LuaLobby Chobby",
        friends: [],
        friend_requests: []
      },
      %{
        name: "Testuser2",
        country: "US",
        lobbyid: "LuaLobby Chobby",
        friends: [],
        friend_requests: []
      },
      %{
        name: "Teifion",
        country: "GB",
        lobbyid: "LuaLobby Chobby",
        friends: ["Addas"],
        friend_requests: ["Link"]
      },
      %{
        name: "Addas",
        country: "DE",
        lobbyid: "LuaLobby Chobby",
        friends: ["Teifion"],
        friend_requests: []
      },
      %{
        name: "Link",
        country: "IR",
        lobbyid: "LuaLobby Chobby",
        friends: [],
        friend_requests: []
      },
    ]
    |> Enum.map(&User.create_user/1)
    |> Enum.map(&User.add_user/1)
  end

  def create_clients do
    [
      %{
        pid: nil,
        name: "[teh]cluster1[03]",
        protocol: Teiserver.Protocols.Spring,
        in_game: false,
        away: false,
        rank: 1,
        moderator: true,
        bot: true,
        battlestatus: 4194306,
        team_colour: 16777215,
        battle_id: 1
      }
    ]
    |> Enum.map(&Client.create/1)
    |> Enum.map(&Client.add_client/1)
  end

  def create_battles do
    ConCache.insert_new(:lists, :battles, [])
    [
      %{
        type: :normal,
        nattype: :none,
        founder: "[teh]cluster1[03]",
        ip: "127.8.0.1",
        port: "322",
        max_players: 16,
        passworded: false,
        rank: 0,
        locked: false,
        map_hash: 2222222222,
        engine_name: "spring",
        engine_version: "104.0.1-1714-g321b911",
        map_name: "SpeedMetal BAR V2",
        title: "USA -- 04",
        game_name: "Beyond All Reason test-15367-6bfafcb",

        players: ["[teh]cluster1[03]"]
      },
      %{
        type: :normal,
        nattype: :none,
        founder: "[teh]cluster1[03]",
        ip: "127.8.0.1",
        port: "322",
        max_players: 16,
        passworded: false,
        rank: 0,
        locked: false,
        map_hash: 1111111111,
        engine_name: "spring",
        engine_version: "104.0.1-1714-g321b911",
        map_name: "Comet Catcher Remake 1.8",
        title: "USA -- 03",
        game_name: "Beyond All Reason test-15367-6bfafcb",

        players: ["[teh]cluster1[03]"]
      }
    ]
    |> Enum.map(&Battle.create_battle/1)
    |> Enum.map(&Battle.add_battle/1)
  end
end