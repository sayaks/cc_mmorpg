local protocol = "mmorpg"
local hostName = "main"

rednet.open("right")
rednet.host(protocol, hostName)

local players = {}
local monitor = peripheral.find("monitor")

local function create_player(client_id, name)
  local new_player = {
    client_id = client_id,
    name = name,
    location = "spawn"
  }
  local player_id = #players + 1
  new_player["id"] = player_id
  players[player_id] = new_player
  log(1, "Created player " .. new_player.name .. " at location " .. new_player.location .. " with id " .. player_id)
  return new_player
end

local function get_player(client_id, player_id)
  local player = players[player_id]
  if player and player.client_id == client_id then
    return player
  end
  return nil
end

local function change_location(client_id, player_id, new_location)
  local player = get_player(client_id, player_id)
  if player then
    player.location = new_location
    log(1, "moved player " .. player_id .. " to location " .. new_location)
  else
    log(2, "couldn't move player " .. player_id .. " to location " .. new_location)
  end
end

local function change_client(client_id, player_id, new_client_id)
  local player = get_player(client_id, player_id)
  if player then
    player.client_id = new_client_id
  else

  end
end

local function show_stats()
  if not monitor then
    return
  end
  monitor.clear()
  local y = 1

  for k,v in pairs(players) do
    monitor.setCursorPos(1,y)
    monitor.write("player: " .. v.name .. " is at: " .. v.location .. "\n")
    y = y + 1
  end
end

while true do
  show_stats()
  local sender_id, msg, p = rednet.receive(protocol)
  if msg and msg["op"] then
    log(1, "Received op \"" .. msg.op .. "\"")
    if msg.op == "create_player" then
      local player = create_player(sender_id, msg.name)
      rednet.send(sender_id, player, protocol)
    elseif msg.op == "move_player" then
      change_location(sender_id, msg.player_id, msg.new_location)
    elseif msg.op == "change_player_id" then
      change_client(sender_id, msg.player_id, msg.new_id)
    elseif msg.op == "get_player" then
      local player = get_player(sender_id, msg.player_id)
      rednet.send(sender_id, player, protocol)
    end
  end
end