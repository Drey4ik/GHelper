-- ���������� � �������
local script_Name = "G_Helper"  -- �������� �������
local script_Author = "Drey4ik"           -- ����� �������
local script_Version = "0.3"               -- ������ �������
---

-- ����������� ���������
require('lib.moonloader')
local sampev = require('lib.samp.events')
local imgui = require 'mimgui'
local tag = '{9461FF}[G Helper]: {FFFFFF}'
local active = false
local mem = require "memory"

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

-- ������ ��� ��� 
defaultState = false
activeButton = 1  -- �� ��������� ������� ������ ������
-- 

-- ����������
local window = imgui.new.bool()          -- ��������� ����                          
local clickCount = 0                     -- ������� ������� �� Drey4ik
local ffi = require('ffi')
local radius = 1500 -- ������ ����������� �����
local pool = {} -- ������� ��� �������� �����


-- ������ �� ������� 
local faicons = require('fAwesome6') 
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('regular'), 14, config, iconRanges) -- ��� ������,  solid ��� �� ���� thin, regular, light � duotone
end)
--

-- ���� ����������
local inicfg = require("inicfg")
local mainIni = inicfg.load({ -- CFG
    mode = 1, 
    settings = {
        ukrop_map = false, -- ��������� ����� ����������
        rp_invite = false,
        prospammer = false,
        capt = false,
        spawn_cars = true,
        fill_cars = true, 
		sklad = true,
        skins = true,
        rank = true,
        fastmute = false,
        fastuval = false,
        muteminutes = 1,
        inv_captskin = 1,
        inv_capt = 1,
        inv_ranks = 1,
        cbook = false,
        fastwarn = false,
        warntext = '���',
        cbooktext = '50000',
        rp_text = '������� ����� �������',
        mutetext = '������ � �����.',
        uvaltext = '�������.',
        prospamtext1 = '������� ��� ����� ����.',
        prospamtext2 = '������� ��� ����� ����.',
        prospamtext3 = '������� ��� ����� ����.'
    }
}, 'G_Helper')
local rp_invite = imgui.new.bool(mainIni.settings.rp_invite)
local prospammer = imgui.new.bool(mainIni.settings.prospammer)
local capt = imgui.new.bool(mainIni.settings.capt)
local spawn_cars = imgui.new.bool(mainIni.settings.spawn_cars)
local fill_cars = imgui.new.bool(mainIni.settings.fill_cars)
local sklad = imgui.new.bool(mainIni.settings.sklad)
local skins = imgui.new.bool(mainIni.settings.skins)
local rank = imgui.new.bool(mainIni.settings.rank)
local fastmute = imgui.new.bool(mainIni.settings.fastmute)
local fastuval = imgui.new.bool(mainIni.settings.fastuval)
local muteminutes = imgui.new.int(mainIni.settings.muteminutes)
local inv_captskin = imgui.new.int(mainIni.settings.inv_captskin)
local inv_capt = imgui.new.int(mainIni.settings.inv_capt)
local inv_ranks = imgui.new.int(mainIni.settings.inv_ranks)
local ukrop_map = imgui.new.bool(mainIni.settings.ukrop_map)
local fastwarn = imgui.new.bool(mainIni.settings.fastwarn)
local cbook = imgui.new.bool(mainIni.settings.cbook)
-- ��� ������ 
local rp_text = imgui.new.char[256](u8(mainIni.settings.rp_text))  -- ����� ��� rp_text
local cbooktext = imgui.new.char[256](u8(mainIni.settings.cbooktext))  -- ����� ��� warntext
local warntext = imgui.new.char[256](u8(mainIni.settings.warntext))  -- ����� ��� warntext
local mutetext = imgui.new.char[256](u8(mainIni.settings.mutetext))  -- ����� ��� mutetext
local uvaltext = imgui.new.char[256](u8(mainIni.settings.uvaltext))  -- ����� ��� uvaltext
local prospamtext1 = imgui.new.char[256](u8(mainIni.settings.prospamtext1))  -- ����� ��� prospamtext1
local prospamtext2 = imgui.new.char[256](u8(mainIni.settings.prospamtext2))  -- ����� ��� prospamtext2
local prospamtext3 = imgui.new.char[256](u8(mainIni.settings.prospamtext3))  -- ����� ��� prospamtext3

if not doesFileExist('moonloader/config/G_Helper.ini') then 
    inicfg.save(mainIni, 'G_Helper') 
end
-- 

-- �������� ���������
function main()
  while not isSampAvailable() do wait(100) end
  autoupdate("http://qrlk.me/dev/moonloader/getgun/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/drey4ikk")
	sampAddChatMessage(tag..'{ffffff}������� ��������!', -1)
  repeat wait(0) until sampIsLocalPlayerSpawned()
  local playerNickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) or '������������'
  sampAddChatMessage(tag..'����������� {9461FF}/gh {ffffff}��� {9461FF}F2{ffffff}.', -1)
  sampAddChatMessage(tag..'{ffffff}�� ����� ���: {9461FF}'..playerNickname..'{ffffff}.', -1)
  -- ��� �������  G Helper
  sampRegisterChatCommand('gh', ghelper) -- �������� �� /gh
  sampRegisterChatCommand('tk', tk) -- ���/���� ����������� �������� �����
  sampRegisterChatCommand('sc', sc) -- ������� ����� ���������� �����
  sampRegisterChatCommand('fc', fc) -- ������� �������� ���������� �����
  sampRegisterChatCommand('sk', sk) -- ��������/�������� ������ �����
  sampRegisterChatCommand('gr', rank) -- ������� ������ �����
  sampRegisterChatCommand("gs", skins) -- ������� ������ �����
  sampRegisterChatCommand('mb', mb) -- ������� �������� /members.
  sampRegisterChatCommand('gb', gb) -- ������� ������ /givecbook.
  sampRegisterChatCommand('cc', ClearChat) -- ������� ������� ����
  sampRegisterChatCommand('ch', ClearChat1) -- ������� ���� 
  sampRegisterChatCommand('fu', fu) -- ������� ����������
  sampRegisterChatCommand('fm', fm) -- ������� ������ ����
  sampRegisterChatCommand('fw', fw) -- ������� ������ ����
  sampRegisterChatCommand('spam', prospam) -- ������� �������� � ���-�����.
  ------------------------
  while true do 
    wait(0)
    if isKeyJustPressed(0x71) then -- �������� �� F2
      ghelper()
    end
    if active then -- ��� ��������� ������� /lmenu
      wait(200)
      active = false
    end
    if ukrop_map[0] then
        umap() -- ���������� �����, ���� ���������� ��������� ��������
    end
    if rp_invite[0] then
        local result, target = getCharPlayerIsTargeting(playerHandle)
        if result then result, playerid = sampGetPlayerIdByCharHandle(target) end 
        if result and isKeyDown(0x45) then 
            local name = sampGetPlayerNickname(playerid) 
            sampSendChat('q')
            wait(100)
            sampSendChat('/me '..u8:decode(ffi.string(rp_text)))
            wait(1000)
            active = true
            sampSendChat('/invite '..playerid)
            sampSendDialogResponse(25637, 1, 0, -1)
            end
        end
    end
end

-- �������� �������
imgui.OnFrame(function()return window[0]end, function(player)
    if window[0] then
        local res = imgui.GetIO().DisplaySize
        imgui.SetNextWindowSize(imgui.ImVec2(725, 375), imgui.Cond.Always)
        imgui.SetNextWindowPos(imgui.ImVec2(res.x / 2, res.y / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
        imgui.Begin('G Helper', window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
        -- ����� ���� � ��������
        imgui.BeginChild('##leftbutton', imgui.ImVec2(150, 280), true)
        if imgui.Button(faicons('house') .. u8(' �������'), imgui.ImVec2(135, 63)) then
            activeButton = 1
        elseif imgui.Button(faicons('bars') .. u8(' �������'), imgui.ImVec2(135, 63)) then
            activeButton = 2
        elseif imgui.Button(faicons('user') .. u8(' ��� �������'), imgui.ImVec2(135, 63)) then
            activeButton = 3
        elseif imgui.Button(faicons('gear') .. u8(' ���������'), imgui.ImVec2(135, 63)) then
            activeButton = 4
        end
        imgui.EndChild()
        imgui.SameLine()
        -- �������� ���� � ����������
        imgui.SetCursorPos(imgui.ImVec2(160, 28))
        imgui.BeginChild("Main", imgui.ImVec2(560, 280), true)
        if activeButton == 1 then  -- �������
            imgui.Button('G Helper', imgui.ImVec2(60, 20))
            imgui.SameLine(70)
            imgui.Text(u8' � ������ ��� ��������� ������� ���������, ����������')
            imgui.Text(u8'��� ��� ������� � ������������, ��� � ��� ������� �������.')
            imgui.Text(u8'�� �������� ������ ����������� �� ���������, ���������')
            imgui.Text(u8'���������� � ���������� ��������� ������, ������� ����������������.')
            imgui.Spacing()
            if imgui.Button(faicons('USER') .. u8(' ���������'), imgui.ImVec2(100, 20)) then
                os.execute('start https://vk.com/drey4ikk')
            end
            imgui.SameLine()
            if imgui.Button(faicons('USER') .. u8(' Telegram'), imgui.ImVec2(100, 20)) then
                os.execute('start https://t.me/Drey4ik')
            end
            imgui.SameLine()
            imgui.TextQuestion(u8'�������� ������������!')
            imgui.SetCursorPos(imgui.ImVec2(6, 225))
            imgui.Text(u8("������:"))
            imgui.SameLine(65)
            imgui.Button(script_Version, imgui.ImVec2(55, 20))
            imgui.Text(u8("�����:"))
            imgui.SameLine(65)
            if imgui.Button(script_Author, imgui.ImVec2(55, 20)) then
                clickCount = clickCount + 1  -- ����������� ������� �������
                sampAddChatMessage(tag..'{ffffff}���-���-���! ������ ' .. clickCount .. ' ���(�).', -1)
            end
        elseif activeButton == 2 then  -- �������
            imgui.Indent(3)  -- ������ �����
            if imgui.CollapsingHeader(faicons('list') .. u8(' ������ ������')) then
                imgui.Separator()
                imgui.TextWrapped(u8(
                    '[/mb] - ������� �������� /members.\n' ..
                    '[/cc] - ������� ������� ����.\n' ..
                    '[/ch] - ������� ���� �� 1 �� 100 �����.'
                ))
                imgui.Separator()
            end
            imgui.Unindent(3)  -- ���������� ������
            imgui.Spacing()
            if imgui.ToggleButton(u8'����� ������', ukrop_map) then
                umap() -- ������������ �����
            end
            imgui.SameLine()
            imgui.TextQuestion(u8'���������� �� ����� ������ ������������ ������')
        elseif activeButton == 3 then  -- ��� �������
            imgui.Indent(3)  -- ������ �����
            if imgui.CollapsingHeader(faicons('list') .. u8(' ������ ������ ��� �������')) then
                imgui.Separator()
                imgui.TextWrapped(u8(
                    '[/sc] - ������� ����� ���������� �����.\n' ..
                    '[/fc] - ������� �������� ���������� �����.\n' ..
                    '[/sk] - ��������/�������� ������ �����.\n' ..
                    '[/tk] - ���/���� ����������� �������� �����.\n' ..
                    '[/fm] - ������� ������ ����.\n' ..
                    '[/fu] - ������� ����������.\n' ..
                    '[/gs] - ������� ������ �����.\n' ..
                    '[/fw] - ������� ������ ��������.\n' ..
                    '[/gr] - ������� ������ �����.\n' ..
                    '[/gb] - ������� ������ /givecbook.\n' ..
                    '[/spam] - ������� �������� � ���-�����.'
                ))
                imgui.Separator()
            end
            imgui.Unindent(3)  -- ���������� ������

            imgui.PushItemWidth(69)
            imgui.Spacing()
            imgui.PushItemWidth(150)
            imgui.ToggleButton(u8'������� ������', rp_invite)
            imgui.SameLine()
            imgui.TextQuestion(u8'������� ������ � �� ����������\n�����������: RMB + E')
            if rp_invite[0] then
                imgui.InputText(u8'���������', rp_text, 256)
                imgui.InputInt(u8'���� ��� �������', inv_ranks)
                imgui.SameLine()
            end
                if inv_ranks[0] <= 0 or inv_ranks[0] >= 9 then
                    inv_ranks[0] = 1
            end

            imgui.PushItemWidth(110)
            imgui.Spacing()
            imgui.ToggleButton(u8'������� ���', fastmute)
            imgui.SameLine()  
            imgui.TextQuestion(u8'������� ������ ���� ����� �����.\n�����������: /fm [id]')
            if fastmute[0] then
                imgui.SliderInt(u8'�����', muteminutes, 1, 60)
                imgui.InputText(u8'������� ����', mutetext, 256)
            end

            imgui.Spacing()
            imgui.ToggleButton(u8'������� ����������', fastuval)
            imgui.SameLine()  
            imgui.TextQuestion(u8'������� ���������� ����� �����.\n�����������: /fu [id]')
            if fastuval[0] then
                imgui.InputText(u8'������� ����������', uvaltext, 256)
            end

            imgui.Spacing()
            imgui.ToggleButton(u8'������� �������', fastwarn)
            imgui.SameLine()  
            imgui.TextQuestion(u8'������� ������ �������� ����� �����.\n�����������: /fw [id]')
            if fastwarn[0] then
                imgui.InputText(u8'������� ��������', warntext, 256)
            end

            imgui.Spacing()
            imgui.ToggleButton(u8'������ �������', cbook)
            imgui.SameLine()  
            imgui.TextQuestion(u8'������� ������ ������������� �������.\n���� ������ ���� �� 100$ �� 50.000$\n�����������: /gb [id]')
            if cbook[0] then
                imgui.InputText(u8'����', cbooktext, 256)
            end

            imgui.PushItemWidth(225)
            imgui.Spacing()
            imgui.ToggleButton(u8'������� ������', prospammer)
            imgui.SameLine()  
            imgui.TextQuestion(u8'������� �������� ��������� � ���-�����.\n�����������: /spam')
            if prospammer[0] then
                imgui.Spacing()
                imgui.InputText(u8'##1', prospamtext1, 256)
                imgui.Spacing()
                imgui.InputText(u8'##2', prospamtext2, 256)
                imgui.Spacing()
                imgui.InputText(u8'##3', prospamtext3, 256)
            end
        elseif activeButton == 4 then  -- ���������
            imgui.Dummy(imgui.ImVec2(0, 195))
            if imgui.Button(faicons('inbox') .. u8(' �������� ��� ���������'), imgui.ImVec2(545, 20)) then
                os.remove(getWorkingDirectory()..'/config/G_Helper.ini')
                sampAddChatMessage(tag..'{8B0000}��� ������������� ������������.', -1)
                window[0] = true
                thisScript():reload()
            end
        end
        imgui.EndChild()  -- ��������� �������� ���� � ����������
        -- ������ ������ � ��������
        local childSize = imgui.ImVec2(710, 55)
        imgui.BeginChild("child_window", childSize, true)
        -- ������ ��� ����������, ������������ � ��������
        if imgui.Button(faicons('cloud') .. u8(' ��������� ���������'), imgui.ImVec2(228, 39)) then
            saveSettings()  -- ����� ������� ���������� ��������
        end
        imgui.SameLine()
        if imgui.Button(faicons('spinner') .. u8(' ������������� ������'), imgui.ImVec2(228, 39)) then
            thisScript():reload()
            sampAddChatMessage(tag..'{8B0000}������ ������������.', -1)
        end
        imgui.SameLine()
        if imgui.Button(faicons('xmark') .. u8(' �������'), imgui.ImVec2(228, 39)) then
            window[0] = false
        end
        imgui.EndChild()  -- ��������� ������ ������
        imgui.End()  -- ��������� �������� ����
    end
end)

-- ��� ������� 
function saveSettings()
    mainIni.settings.rp_invite = rp_invite[0]
    mainIni.settings.inv_capt = inv_capt[0]
    mainIni.settings.inv_captskin = inv_captskin[0]
    mainIni.settings.inv_ranks = inv_ranks[0]
    mainIni.settings.capt = capt[0]
    mainIni.settings.fastmute = fastmute[0]
    mainIni.settings.fastuval = fastuval[0]
    mainIni.settings.muteminutes = muteminutes[0]
    mainIni.settings.prospammer = prospammer[0]
    mainIni.settings.fastwarn = fastwarn[0]
    mainIni.settings.warntext = u8:decode(ffi.string(warntext))  -- ���������� ��� warntext
    mainIni.settings.mutetext = u8:decode(ffi.string(mutetext))  -- ���������� ������ ����� ����, ��� ������������ ���� �����
    mainIni.settings.uvaltext = u8:decode(ffi.string(uvaltext))  -- ���������� ��� uvaltext
    mainIni.settings.prospamtext1 = u8:decode(ffi.string(prospamtext1))  -- ��� prospamtext1
    mainIni.settings.prospamtext2 = u8:decode(ffi.string(prospamtext2))  -- ��� prospamtext2
    mainIni.settings.prospamtext3 = u8:decode(ffi.string(prospamtext3))  -- ��� prospamtext3
    mainIni.settings.ukrop_map = ukrop_map[0]
    mainIni.settings.cbook = cbook[0]
    mainIni.settings.cbooktext = u8:decode(ffi.string(cbooktext))  -- ���������� ��� warntext
    mainIni.settings.rp_text = u8:decode(ffi.string(rp_text))  -- ���������� ��� warntext
    

    inicfg.save(mainIni, 'G_Helper')
    sampAddChatMessage(tag.."��������� ������� ���������.", -1)
    addOneOffSound(0.0, 0.0, 0.0, 1138)
    mainIni.mode = 1
end

function gb(param)
    if not param:match('%d+') then
        sampAddChatMessage(tag..'�����������: /gb [id]', -1)
        return
    end
    local id = tonumber(param)
    sampSendChat('/givecbook '..id..' '..u8:decode(ffi.string(cbooktext)))
end

function fu(param)
    if not param:match('%d+') then
        sampAddChatMessage(tag..'�����������: /fu [id]', -1)
        return
    end
    local id = tonumber(param)
    sampSendChat('/uninvite '..id..' '..u8:decode(ffi.string(uvaltext)))
end

function fw(param)
    if not param:match('%d+') then
        sampAddChatMessage(tag..'�����������: /fw [id]', -1)
        return
    end
    local id = tonumber(param)
    sampSendChat('/fwarn '..id..' '..u8:decode(ffi.string(warntext)))
end

function fm(param)
    if not param:match('%d+') then
        sampAddChatMessage(tag..'�����������: /fm [id]', -1)
        return
    end
    local id = tonumber(param)
    sampSendChat('/fmute '..id..' '..muteminutes[0]..' '..u8:decode(ffi.string(mutetext)))
end

function sampev.onServerMessage(color, text)
    if text:find('������ ���� ����������� �������� � ��� � �����������.') then
        giverank(playerid, inv_ranks, name, tag)
    end
    if text:find('�� ������ ������ ��� ������ � ������� ������� /givecbook') then
        sampSendChat('/gr ' ..playerid)
    end
end

function prospam()
    if prospammer[0] then
        sampSendChat('/fb '..u8:decode(ffi.string(prospamtext1)), -1)
        lua_thread.create(function()
            wait(1500) -- �������� � 500 ��
            sampSendChat('/fb '..u8:decode(ffi.string(prospamtext2)), -1)
            wait(1500) -- �������� � 500 ��
            sampSendChat('/fb '..u8:decode(ffi.string(prospamtext3)), -1)
        end)
    end
end


function giverank(playerid, inv_ranks, name, tag)
    if inv_ranks[0] ~= 1 and inv_ranks[0] ~= nil then
        sampSendChat('/giverank '..playerid..' '..inv_ranks[0])
    end
end

function ClearChat()
    for _ = 1, 100 do
        sampAddChatMessage('', -1)
    end
end

function ClearChat1(linesToClear)
    linesToClear = tonumber(linesToClear) -- ����������� �������� � �����
    if linesToClear and linesToClear > 0 and linesToClear <= 100 then
        for _ = 1, linesToClear do
            sampAddChatMessage('', -1)
        end
    else
        sampAddChatMessage(tag..'�����������: {9461FF}/ch [1-100]', -1)
    end
end

function rank(param)
	if state then
		state = false
	elseif not param:match('%d+') then
		sampAddChatMessage(tag..'�����������: /gr [id] [1-8]', -1)
	else
			id = tonumber(param)
			state = true
			sampSendChat('/giverank '..param..' '..param..'')
			state = false
	end
end

function skins(param)
	if state then
		state = false
	elseif not param:match('%d+') then
		sampAddChatMessage(tag..'�����������: /gs [id] [skin]', -1)
	else
			id = tonumber(param)
			state = true
			sampSendChat('/giveskin '..param..' '..param..'')
            sampSendDialogResponse(9188, 1, 0, -1)
            sampCloseCurrentDialogWithButton(0)
			state = false
	end
end

function ghelper()
  window[0] = not window[0]
end

function mb()
    sampSendChat('/members')
end

function fc()
	active = true
	sampSendChat('/lmenu')
	sampSendDialogResponse(1214, 1, 5, -1)
end

function tk()
	active = true
    sampSendChat('/lmenu')
    sampSendDialogResponse(1214, 1, 10, -1)
end

function sc()
	active = true
    sampSendChat('/lmenu')
    sampSendDialogResponse(1214, 1, 4, -1)
end

function sk()
	active = true
    sampSendChat('/lmenu')
    sampSendDialogResponse(1214, 1, 3, -1)
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if active then
        if dialogId == 1214 then
            return false
        elseif dialogId == 25637 then
            return false
        end
    end
  end

function imgui.TextQuestion(text)
    imgui.TextDisabled('( ' .. faicons('comments') .. ' )')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
  end

function imgui.TextColoredRGB(text) 
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4
    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end
    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end
    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end
    render_text(text)
end

------- ����� ������ 

-- �������� ���� ����� �� pool
local function remove_all()
    for i, blip in pairs(pool) do
        if blip then
            removeBlip(blip)
            pool[i] = nil
        end
    end
end

-- ���������� ���������� �������
function onScriptTerminate(script, quit)
    if script == thisScript() then
        remove_all()
    end
end

-- �������� ������� ��������� �����
function umap()
    if ukrop_map and ukrop_map[0] then
        local playerCoords = { getCharCoordinates(PLAYER_PED) }
        local _, playerID = sampGetPlayerIdByCharHandle(PLAYER_PED)  -- �������� ID ������
        for i, coord in ipairs(coords) do
            local dist = getDistanceBetweenCoords3d(playerCoords[1], playerCoords[2], playerCoords[3], coord[1], coord[2], coord[3])
            if dist <= radius and not pool[i] then
                pool[i] = addBlipForCoord(coord[1], coord[2], coord[3])
                changeBlipColour(pool[i], playerID)  -- ���������� ID ������
            elseif dist > radius and pool[i] then
                removeBlip(pool[i])
                pool[i] = nil
            end
        end
    else
        remove_all()
    end
end
-------------------------------------------------------------------

imgui.OnInitialize(function()
    Purple_Theme()
end)

function Purple_Theme()
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
  
    local style = imgui.GetStyle()
    style.WindowPadding = ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildRounding = 5
    style.FramePadding = ImVec2(5, 3)
    style.FrameRounding = 5
    style.ItemSpacing = ImVec2(5, 4)
    style.ItemInnerSpacing = ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = ImVec2(0.5, 0.5)
    style.ButtonTextAlign = ImVec2(0.5, 0.5)
  
    local colors = style.Colors
    local clr = imgui.Col
  
    colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ChildBg]                = ImVec4(0.12, 0.12, 0.12, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10)
    colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00)
    colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00)
    colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81)
    colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39)
    colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00)
    colors[clr.CheckMark]              = ImVec4(0.57, 0.38, 0.99, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.50, 0.28, 1.00, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.50, 0.29, 0.98, 1.00)
    colors[clr.Button]                 = ImVec4(0.50, 0.28, 1.00, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.58, 0.40, 0.99, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.45, 0.22, 0.98, 1.00)
    colors[clr.Header]                 = ImVec4(0.50, 0.28, 1.00, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.56, 0.38, 0.98, 1.00)
    colors[clr.HeaderActive]           = ImVec4(0.45, 0.21, 0.99, 1.00)
    colors[clr.Tab]                    = ImVec4(0.50, 0.28, 1.00, 1.00)
    colors[clr.TabHovered]             = ImVec4(0.56, 0.38, 0.98, 1.00)
    colors[clr.TabActive]              = ImVec4(0.45, 0.21, 0.99, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.53, 0.33, 0.99, 1.00)
  end

  function Dark_Theme()
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
  
    local style = imgui.GetStyle()
    style.WindowPadding = ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildRounding = 5
    style.FramePadding = ImVec2(5, 3)
    style.FrameRounding = 5
    style.ItemSpacing = ImVec2(5, 4)
    style.ItemInnerSpacing = ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = ImVec2(0.5, 0.5)
    style.ButtonTextAlign = ImVec2(0.5, 0.5)
  
    local colors = style.Colors
    local clr = imgui.Col
  
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.ChildBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.05, 0.05, 0.05, 0.94)
    colors[clr.Border]                 = ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[clr.FrameBgActive]          = ImVec4(0.25, 0.25, 0.25, 1.00)
    colors[clr.TitleBg]                = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.15, 0.15, 0.15, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.05, 0.05, 0.05, 0.80)
    colors[clr.MenuBarBg]              = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39)
    colors[clr.ScrollbarGrab]          = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.40, 0.40, 0.40, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.CheckMark]              = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.40, 0.40, 0.40, 1.00)
    colors[clr.Button]                 = ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.40, 0.40, 0.40, 1.00)
    colors[clr.Header]                 = ImVec4(0.25, 0.25, 0.25, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.HeaderActive]           = ImVec4(0.35, 0.35, 0.35, 1.00)
    colors[clr.Tab]                    = ImVec4(0.20, 0.20, 0.20, 1.00)
    colors[clr.TabHovered]             = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.TabActive]              = ImVec4(0.35, 0.35, 0.35, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.25, 0.25, 0.25, 1.00)
end


function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              local info = decodeJson(f:read('*a'))
              updatelink = info.updateurl
              updateversion = info.latest
              f:close()
              os.remove(json)
              if updateversion ~= thisScript().version then
                lua_thread.create(function(prefix)
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion), color)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript().path,
                    function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                        print(string.format('��������� %d �� %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                        print('�������� ���������� ���������.')
                        sampAddChatMessage((prefix..'���������� ���������!'), color)
                        goupdatestatus = true
                        lua_thread.create(function() wait(500) thisScript():reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if goupdatestatus == nil then
                          sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
                          update = false
                        end
                      end
                    end
                  )
                  end, prefix
                )
              else
                update = false
                print('v'..thisScript().version..': ���������� �� ���������.')
              end
            end
          else
            print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
            update = false
          end
        end
      end
    )
    while update ~= false do wait(100) end
  end


----------------- ������� ��� �� ������ 
function imgui.ToggleButton(str_id, bool)
local rBool = false

if LastActiveTime == nil then
    LastActiveTime = {}
end
if LastActive == nil then
    LastActive = {}
end

local function ImSaturate(f)
    return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
end

local p = imgui.GetCursorScreenPos()
local dl = imgui.GetWindowDrawList()

local height = imgui.GetTextLineHeightWithSpacing()
local width = height * 1.70
local radius = height * 0.50
local ANIM_SPEED = type == 2 and 0.10 or 0.15
local butPos = imgui.GetCursorPos()

if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
    bool[0] = not bool[0]
    rBool = true
    LastActiveTime[tostring(str_id)] = os.clock()
    LastActive[tostring(str_id)] = true
end

imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + 2.5))
imgui.Text( str_id:gsub('##.+', '') )

local t = bool[0] and 1.0 or 0.0

if LastActive[tostring(str_id)] then
    local time = os.clock() - LastActiveTime[tostring(str_id)]
    if time <= ANIM_SPEED then
        local t_anim = ImSaturate(time / ANIM_SPEED)
        t = bool[0] and t_anim or 1.0 - t_anim
    else
        LastActive[tostring(str_id)] = false
    end
end

local col_circle = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.TextDisabled]))
dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.FrameBg]), height * 0.5)
dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, col_circle)
return rBool
end
--------
coords = {
    { 2051.2656, -1156.4294, 23.8502 },
    { 2115.4988, -1095.2936, 24.7771 },
    { 2051.3401, -1041.9553, 26.5127 },
    { 2357.4819, -1133.4607, 28.3938 },
    { 2359.8284, -1171.2126, 28.2831 },
    { 2314.9907, -1200.4818, 28.2262 },
    { 2559.2310, -1109.2358, 64.2670 },
    { 2628.7939, -1124.2505, 66.5594 },
    { 2559.2410, -1241.3362, 48.8187 },
    { 2522.7737, -1233.6808, 45.5962 },
    { 2509.5601, -1126.1271, 41.5980 },
    { 1846.2993, -1066.0305, 24.6667 },
    { 1906.2572, -1208.8391, 19.5152 },
    { 1769.5657, -1269.2799, 14.1775 },
    { 1829.7423, -1383.6549, 15.1998 },
    { 1964.8093, -1360.9491, 18.5781 },
    { 2054.5581, -1326.3584, 24.2201 },
    { 2017.6685, -1353.2582, 24.2693 },
    { 2020.1677, -1284.9058, 24.1846 },
    { 2416.6184, -1354.7859, 25.0912 },
    { 2438.1675, -1344.4335, 30.5403 },
    { 2262.4863, -1440.3964, 24.0092 },
    { 2321.9722, -1454.2347, 21.2680 },
    { 2387.6304, -1482.6478, 24.6273 },
    { 2373.1194, -1489.6899, 28.7267 },
    { 2764.3159, -1182.5099, 69.6838 },
    { 2748.8960, -1244.6897, 60.6338 },
    { 2785.7996, -1415.1720, 16.3880 },
    { 2588.3672, -2061.9470, 4.75751 },
    { 2827.6787, -1160.9064, 25.3925 },
    { 2848.3298, -1942.6093, 12.7612 },
    { 2372.0056, -2114.5867, 27.3039 },
    { 2427.9353, -2027.5251, 13.7694 },
    { 2440.2705, -1981.6669, 13.5469 },
    { 2307.7266, -2009.5165, 19.0014 },
    { 2190.4375, -2029.0265, 13.7296 },
    { 2246.0425, -1931.4435, 13.8074 },
    { 2122.4360, -1933.3767, 13.5469 },
    { 2637.1528, -2024.9476, 13.6671 },
    { 2021.6184, -2093.2749, 19.0454 },
    { 1905.4556, -2136.0786, 15.4430 },
    { 1889.7408, -2010.2220, 13.5469 },
    { 1805.8722, -2083.0471, 13.8553 },
    { 1971.7415, -1535.3516, 11.4262 },
    { 2233.2390, -1700.1475, 22.5497 },
    { 2066.9160, -1690.3385, 13.8153 },   
    { 1987.8599, -1628.1263, 16.2498 },
    { 2145.1350, -1613.7839, 13.7605 },
    { 2257.3027, -1620.9314, 15.7393 },
    { 2368.2910, -1702.8949, 13.8794 },
    { 2527.6074, -1642.2953, 13.9939 },
    { 2521.1274, -1670.7814, 15.1195 },
    { 2395.9255, -1816.7269, 13.7957 },
    { 2376.1086,- 1814.9210, 13.7681 },
    { 2019.8030, -1898.4729, 9.16811 },
    { 2280.3914, -2113.9587, 13.7744 },
    { 2301.2146, -2130.9661, 13.9171 },
    { 2323.5144, -2161.7908, 13.8654 },
    { 2300.8599, -2232.1970, 13.7277 },
    { 2286.2788, -2195.1948, 7.24131 },
    { 2219.3274, -2103.9907, 8.03221 },
    { 1711.1694, -1852.1277, 13.7792 },
    { 1967.8704, -1844.5211, 4.14571 },
    { 2093.0811, -1845.7833, 4.03511 },
    { 2102.4995, -1639.3700, 13.6343 },
    { 2128.6104, -1710.7371, 15.2948 },
    { 2346.2971, -1040.7277, 53.9172 },
    { 2383.5659, -1941.3464, 13.5469 },
    { 2291.5208, -1693.4148, 13.6857 },   
    { 1837.9935, -1599.3556, 13.5677 },
    { 2497.2095, -1793.5551, 14.3287 }
}