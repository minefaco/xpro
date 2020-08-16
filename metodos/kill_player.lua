--[[
	Mod Xpro para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Eventos de ganho ou perca de XP ao cavar um node
  ]]

-- Lista de itens que geram recompensa
xpro.kill_player_xp_list = {}
server="" --opcional: colocar nombre del servidor antes del mensaje.
-- Chamada global

minetest.register_on_punchplayer(function(player, hitter, _, _, _, damage)
   if not (hitter and hitter:is_player()) then
      return 
   end

   local hp = player:get_hp()
   if hp - damage > 0 or hp <= 0 then
      return 
   end


   local hitter_name = hitter:get_player_name()
   local player_name = player:get_player_name()
   local exp_player = xpro.get_player_xp(player_name)
   local exp=math.floor(xpro.get_player_xp(player_name)/xpro.get_player_lvl(player_name))
	if exp_player>=700 then
		xpro.add_xp(hitter:get_player_name(), exp)
		minetest.chat_send_all(minetest.colorize("00FF33",server.." "..hitter:get_player_name().." asesinó a "..player:get_player_name().." y obtuvo:"..exp.." puntos de XP"))

	else
		local missing = minetest.check_player_privs(hitter_name, {xpro_admin = true})
		if not missing then
			xpro.add_xp(player_name,exp)
			xpro.rem_xp(hitter_name,1000)
			minetest.chat_send_all(minetest.colorize("#FF2D00",server.." "..hitter:get_player_name().." asesinó a "..player:get_player_name()..". Penalizado con: -1000 puntos de XP"))
		else
			xpro.add_xp(hitter:get_player_name(),exp)
		end
	
   	end
   
    
end)

