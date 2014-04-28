--
--[[
-- script for scite
-- mabotech
]]

function OnSwitchFile(path)
    local t = os.date("%Y-%m-%d %H:%M:%S", os.time()) 
    print(t);
    print(path);
end;

-- split tag: <div class="mt"></div>
function get_ptag(tag)
    
    local ptag    
    j = 0
    -- until ?
    for i in string.gmatch(tag, "%S+") do
      j = j + 1
      ptag = i
      if j > 0 then
          break
      end       
    end
    return ptag    
end

--[[
command.name.5.*=Menu5
command.5.*=menu5
command.subsystem.5.*=3
command.mode.5.*=savebefore:no
command.shortcut.5.*=Ctrl+5
]]

function menu5()

    print(scite.filename)

    -- 2014-04-26 21:33:27
    -- scite.StripShow("!'Explanation:'{}(&Search)\n'Name:'[Name](OK)(Cancel)");
    
    local t = os.time();
    print(t);

    local dt = os.date("%Y-%m-%d %H:%M:%S", t)  
    editor:insert(editor.CurrentPos, "modified on " .. dt);
    print("menu5")

end;

dict = {
    ["{"] = "}",
    ["("] = ")", 
    ["["] = "]",
    ["\""] = "\"",
    ["'"] = "'",
    };
   
function OnChar(char)
    -- <tag> check
    if(char==">") then
        AddTag();
    else 
        local val = dict[char]
        --pair check
        -- local nextv = editor.CharAt[editor.CurrentPos]
        -- 32==space, 13 == \n
        -- and (nextv == 32 or nextv == 13) 
        if val then
                editor:insert(editor.CurrentPos, val);
        end;
    end;
end;

-- https://github.com/rrreese/SciteLuaScripts/blob/master/TagComplete.lua
function AddTag()
    local m_end = 0;
    local senv, env;

    local lineNumber = editor:LineFromPosition(editor.CurrentPos);
    local posAtStartOfLine = editor:PositionFromLine(lineNumber);
    local posAlongLine = editor.CurrentPos - posAtStartOfLine;
    local str = editor:GetLine(lineNumber);
    
    local length = string.len(str);
    
    local etemp =""
    local off = 0;
    
    local xtemp = string.sub(str,posAlongLine-1,posAlongLine)--check tag is not terminated with />
    if (xtemp ~= "/>") and (xtemp ~= "/>\r\n") and (xtemp ~= "/>\n") and (xtemp ~= "/>\r") then --ignore newlines
        -- look for last <tag>
        repeat
            senv = env;
            m_start, m_end, env = string.find(str, '<(.-)>', m_end);
            if m_start then --check that just typed tag isn't an end </tag>
                etemp=string.sub(str,m_start,m_start+1)
                if ((etemp=="</") and (m_start < posAlongLine)) then --last tag before currentpos is an end tag
                    off=1;
                elseif (m_start < posAlongLine) then --last tag before currentpos is NOT an end tag
                    off=0;
                end
            end
        until ((m_start == nil) or (m_start > posAlongLine)) -- Do't go past current position
        
        -- add </tag><//tag> 
        senv = get_ptag(senv)
        
        -- bypass html comment modified on 2014-04-28 22:07:31
        if(senv == '!--') then
            return;
        end;
            
        if(senv) and off==0 then --senv isn't empty and off is off
            editor:insert(editor.CurrentPos,"</"..senv..'>');
        end;
    end
end;
