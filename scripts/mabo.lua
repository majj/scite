

--[[
-- script for scite
-- mabotech
]]

dict = {
    ["{"] = "}",
    ["("] = ")", 
    ["["] = "]",
    ["\""] = "\"",
    ["'"] = "'"
};

function OnChar(char)
    -- <tag> check
    if(char==">") then
            AddTag();
    else 
        local val = dict[char]
        -- pair check
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
        if(senv) and off==0 then --senv isn't empty and off is off
            editor:insert(editor.CurrentPos,"</"..senv..'>');
        end;
    end
end;
