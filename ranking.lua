--[[
	Mod Xpro para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Gerenciamento do Ranking
  ]]

-- Pegar ranking
xpro.get_rank = function()
	return xpro.bd.pegar("ranking", "pontos")
end

-- Tabela de acesso rapido ao ranking global
xpro.ranking = {}

-- Atualizar ranking
xpro.update_rank = function(name)
	local rank = xpro.get_rank()
	local pontos = xpro.bd.pegar("jogador_"..name, "xp")
	local m1 = {name=name,pontos=pontos}
	local m2 = {}
	for x=1, 10 do
		-- Se o objeto atual for o novo colocado
		if m1.name == name then
			-- Verifica se fica no lugar
			if rank[tostring(x)].pontos < m1.pontos then
			
				--Substitui posicao
				m2.name = rank[tostring(x)].name
				m2.pontos = rank[tostring(x)].pontos
				rank[tostring(x)].name = m1.name
				rank[tostring(x)].pontos = m1.pontos
				
				-- Verifica se o que foi tirado é ele mesmo
				if name == m2.name then
					break
				end
				
				-- m2 para a ser m1 para a proxima comparacao
				m1.name = m2.name
				m1.pontos = m2.pontos
				
			-- Nao é maior mas é o mesmo jogador
			elseif m1.name == rank[tostring(x)].name then
				-- atualiza os pontos e encerra
				rank[tostring(x)].pontos = m1.pontos
				break
			end
			
		-- Se o objeto atual for um recolocado
		else
			-- Se for o objeto novo que ja foi colocado
			if rank[tostring(x)].name == name then
				rank[tostring(x)].name = m1.name
				rank[tostring(x)].pontos = m1.pontos
				break
				
			-- Se nao for compara normalmente
			else
				if rank[tostring(x)].pontos < m1.pontos then
					-- Substitui posicao
					m2.name = rank[tostring(x)].name
					m2.pontos = rank[tostring(x)].pontos
					rank[tostring(x)].name = m1.name
					rank[tostring(x)].pontos = m1.pontos
									
					-- m2 para a ser m1 para a proxima comparacao
					m1.name = m2.name
					m1.pontos = m2.pontos
				end
			end
			
		end
	end
	xpro.bd.salvar("ranking", "pontos", rank)
	xpro.ranking = minetest.deserialize(minetest.serialize(rank))
end

-- Certifica de que rank existe
if xpro.bd.verif("ranking", "pontos") == false then
	rank = {
		["1"] = {name="-1-",pontos=0},
		["2"] = {name="-2-",pontos=0},
		["3"] = {name="-3-",pontos=0},
		["4"] = {name="-4-",pontos=0},
		["5"] = {name="-5-",pontos=0},
		["6"] = {name="-6-",pontos=0},
		["7"] = {name="-7-",pontos=0},
		["8"] = {name="-8-",pontos=0},
		["9"] = {name="-9-",pontos=0},
		["10"] = {name="-10-",pontos=0},
	}
	xpro.bd.salvar("ranking", "pontos", rank)
end

-- Formspec do ranking
xpro.ranking_formspec = ""

local update_formspec = function()
	
	xpro.ranking_formspec = "size[7,6]"
		..default.gui_bg
		..default.gui_bg_img
		.."label[0.6,0.4;Pontos]"
		.."label[2.1,0.4;Jogador]"
	
	-- Monta Ranking
	local rank = xpro.get_rank()
	for x=1, 10 do
		local w = (0.4+(0.5*x))
		xpro.ranking_formspec = xpro.ranking_formspec .."label[0.6,"..w..";"..rank[tostring(x)].pontos.."]"
			.."label[2.1,"..w..";"..rank[tostring(x)].name.."]"
	end
end
update_formspec()

xpro.register_on_add_xp(function(name, xp_added)
	--if xpro.ranking 
	xpro.update_rank(name)
	update_formspec()
end)
xpro.register_on_rem_xp(function(name, xp_removed)
	xpro.update_rank(name)
	update_formspec(name)
end)



