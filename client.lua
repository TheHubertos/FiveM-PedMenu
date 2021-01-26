ESX = nil

Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function OtwierTenSzit()
 
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'pedmenu',
		{
		  title    = 'Ped-menu',
		  align    = 'right',
		  elements = {
			  {label = 'Strój cywilny', value = 'cywilson'}, {label = 'Wybierz peda', value = 'ped'}
		  }
		},

		function(data, menu)
			
			if data.current.value == 'cywilson' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local model = nil
					
					if skin.sex == 0 then
						model = GetHashKey("mp_m_freemode_01")
					else
						model = GetHashKey("mp_f_freemode_01")
					end

					RequestModel(model)
					while not HasModelLoaded(model) do
						RequestModel(model)
						Citizen.Wait(1)
					end

					SetPlayerModel(PlayerId(), model)
					SetModelAsNoLongerNeeded(model)

					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
				end)
			end

			if data.current.value == 'ped' then
				menu.close()

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'chooseaped', {
					title = 'Jakim pedem chciałbyś być?'
				}, function(data2, menu2)
					local ped = data2.value
	
					if ped == nil then
						menu2.close()
						menu.close()
						BecomePed(ped)
					else
						menu2.close()
						menu.close()
						BecomePed(ped)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

RegisterCommand("pedchange", function(source)
	OtwierTenSzit()
end, false)

BecomePed = function(ped)

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		
		if skin.sex == 0 then
			local hash = ped
			local model = GetHashKey(hash)
			
			RequestModel(model)
			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(0)
			end
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
		else
			local hash = ped
			local model = GetHashKey(hash)
			
			RequestModel(model)

			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(0)
			end
			
			SetPlayerModel(PlayerId(), model)
			SetModelAsNoLongerNeeded(model)
		end
		TriggerEvent('esx:restoreLoadout')
	end)
end
