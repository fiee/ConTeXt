if not modules then modules = { } end modules ['t-diagramm'] = {
    version   = 1.000,
    comment   = "Diagramme",
    author    = "Wolfgang Schuster",
    copyright = "Wolfgang Schuster",
    license   = "Public Domain"
}

do

-- Tabellen

thirddata                = thirddata                or { }
thirddata.diagramm       = thirddata.diagramm       or { }
thirddata.diagramm.data  = thirddata.diagramm.data  or { }
thirddata.diagramm.setup = thirddata.diagramm.setup or { }


-- Lokale Funktionen

local xmin        = function()      return thirddata.diagramm.axis.x.min     end
local xmax        = function()      return thirddata.diagramm.axis.x.max     end
local ymin        = function()      return thirddata.diagramm.axis.y.min     end
local ymax        = function()      return thirddata.diagramm.axis.y.max     end
local xstep       = function()      return thirddata.diagramm.axis.x.step    end
local ystep       = function()      return thirddata.diagramm.axis.y.step    end
local xminstep    = function()      return thirddata.diagramm.axis.x.minstep end
local yminstep    = function()      return thirddata.diagramm.axis.y.minstep end
local fieldwidth  = function()      return thirddata.diagramm.scale.x        end
local fieldheight = function()      return thirddata.diagramm.scale.y        end
local bp          = function(value) return number.tobasepoints(value)        end 


-- Speichern der Werte in Tabellen

function thirddata.diagramm.series(s)    
    thirddata.diagramm.data[s] = { }
end

function thirddata.diagramm.point(s,i,v,c)
    local point = { value = v, color = c }
    thirddata.diagramm.data[s][i] = point
end


-- Zähler

function thirddata.diagramm.maxpoint_()
    local max = 0
    for k,v in pairs(thirddata.diagramm.data) do
        for x,y in pairs(thirddata.diagramm.data[k]) do
            if thirddata.diagramm.data[k][x]["value"] > max then
                max = thirddata.diagramm.data[k][x]["value"]
            end
        end
    end
    return max
end

function thirddata.diagramm.points_anzahl()
    local count = 0
    local max = 0
    for k,v in pairs(thirddata.diagramm.data) do
        count = 0
        for x,y in pairs(thirddata.diagramm.data[k]) do
            count = count + 1
        end
        if count > max then
            max = count
        end
    end
    return max
end

function thirddata.diagramm.points_()
    local count = 0
    local max = 0
    for k,v in pairs(thirddata.diagramm.data) do
        count = 0
        for x,y in pairs(thirddata.diagramm.data[k]) do
            count = count + thirddata.diagramm.data[k][x]["value"]
        end
        if count > max then
            max = count
        end
    end
    return max
end

function thirddata.diagramm.series_number()
    local count = 0
    for k,v in pairs(thirddata.diagramm.data) do
        count = count + 1
    end
    return count
end


-- Initialization

thirddata.diagramm.scale = { }

-- thirddata.diagramm.range   = { }
-- thirddata.diagramm.range.x = { }
-- thirddata.diagramm.range.y = { }

function thirddata.diagramm.initialization()
    thirddata.diagramm.setup.xaxis = false
    thirddata.diagramm.setup.yaxis = false
    thirddata.diagramm.setup.xtick = false
    thirddata.diagramm.setup.ytick = false
    thirddata.diagramm.setup.grid  = "no"
    thirddata.diagramm.scale.x     = tex.dimen["diagrammwidth"] 
    thirddata.diagramm.scale.y     = tex.dimen["diagrammheight"] 
    -- thirddata.diagramm.range.x.min = -.5
    -- thirddata.diagramm.range.x.max =  .5
    -- thirddata.diagramm.range.y.min = -.5
    -- thirddata.diagramm.range.y.max =  .5
end


-- Range

thirddata.diagramm.range   = { }
-- thirddata.diagramm.range.x = { }
-- thirddata.diagramm.range.y = { }
thirddata.diagramm.shift   = { }

function thirddata.diagramm.xrange(x,y)
    local values = { min = x, max = y }
    local range  = y - x
    thirddata.diagramm.range.x = values
    -- thirddata.diagramm.range.x.min = x
    -- thirddata.diagramm.range.x.max = y
    thirddata.diagramm.shift.x = -x
    thirddata.diagramm.scale.x = thirddata.diagramm.scale.x / range
end

function thirddata.diagramm.yrange(x,y)
    local values = { min = x, max = y }
    local range  = y - x
    thirddata.diagramm.range.y = range
    -- thirddata.diagramm.range.y.min = x
    -- thirddata.diagramm.range.y.max = y
    thirddata.diagramm.shift.y = -x
    thirddata.diagramm.scale.y = thirddata.diagramm.scale.y / range
end


-- Achsen

thirddata.diagramm.axis    = { }
thirddata.diagramm.axis.x  = { }
thirddata.diagramm.axis.y  = { }

thirddata.diagramm.axis.x.format = "%d"
thirddata.diagramm.axis.y.format = "%d"

function thirddata.diagramm.xaxis(x,y)
    local range = { min = x, max = y }
    thirddata.diagramm.axis.x = range
    thirddata.diagramm.axis.x.step    = 1
    thirddata.diagramm.axis.x.minstep = 5
end

function thirddata.diagramm.yaxis(x,y)
    local range = { min = x, max = y }
    thirddata.diagramm.axis.y = range
    thirddata.diagramm.axis.y.step    = 1
    thirddata.diagramm.axis.y.minstep = 5
end

function thirddata.diagramm.draw_axis()
    if thirddata.diagramm.setup.xaxis==true then
        -- leftframe
        tex.sprint("draw (" .. bp(xmin()*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. ") -- ")
        tex.sprint("     (" .. bp(xmax()*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. ") ;  ")
        -- rightframe
        tex.sprint("draw (" .. bp(xmin()*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. ") -- ")
        tex.sprint("     (" .. bp(xmax()*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. ") ;  ")
    end
    if thirddata.diagramm.setup.yaxis==true then
        -- bottomframe
        tex.sprint("draw (" .. bp(xmin()*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. ") -- ")
        tex.sprint("     (" .. bp(xmin()*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. ") ;  ")
        -- topframe
        tex.sprint("draw (" .. bp(xmax()*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. ") -- ")
        tex.sprint("     (" .. bp(xmax()*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. ") ;  ")
    end
end


-- Raster

function thirddata.diagramm.draw_grid()
    if thirddata.diagramm.setup.grid=="yes" then
        for i=xmin()+1,xmax()-1 do
            tex.sprint("draw (" .. bp(i*fieldwidth()) .."," .. bp(ymin*fieldheight()) .. ") -- ")
            tex.sprint("     (" .. bp(i*fieldwidth()) .. "," .. bp(ymax*fieldheight()) .. ")   ")
            tex.sprint("     dashed evenly withpen pencircle scaled .25 ;                  ")
        end
        for i=ymin()+1,ymax()-1 do
            tex.sprint("draw (" .. bp(xmin()*fieldwidth()) .."," .. bp(i*fieldheight()) .. ") -- ")
            tex.sprint("     (" .. bp(xmax()*fieldwidth()) .. "," .. bp(i*fieldheight()) .. ")   ")
            tex.sprint("     dashed evenly withpen pencircle scaled .25 ;                  ")
        end
    end
end


-- Tickmarks

function thirddata.diagramm.draw_tick()
    if thirddata.diagramm.setup.xtick==true then
        -- Major ticks
        for i=xmin(),xmax() do
            tex.sprint("draw (" .. bp(i*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. ") -- ")
            tex.sprint("     (" .. bp(i*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. "+5) ;")
            tex.sprint("draw (" .. bp(i*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. ") -- ")
            tex.sprint("     (" .. bp(i*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. "-5) ;")
        end
        -- Minor ticks
        for i=xmin(),xmax()-1 do
            for j=1,xminstep()-1 do
                if thirddata.diagramm.axis.x.log==true then
                    -- logarithmische skalierung
                    tex.sprint("draw (" .. bp((i+math.log10(j/xminstep()*10))*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. ") --   ")
                    tex.sprint("     (" .. bp((i+math.log10(j/xminstep()*10))*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. "+5/2) ;")
                    tex.sprint("draw (" .. bp((i+math.log10(j/xminstep()*10))*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. ") --   ")
                    tex.sprint("     (" .. bp((i+math.log10(j/xminstep()*10))*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. "-5/2) ;")
                else
                    -- normale skalierung
                    tex.sprint("draw (" .. bp((i+j/xminstep())*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. ") --   ")
                    tex.sprint("     (" .. bp((i+j/xminstep())*fieldwidth()) .. "," .. bp(ymin()*fieldheight()) .. "+5/2) ;")
                    tex.sprint("draw (" .. bp((i+j/xminstep())*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. ") --   ")
                    tex.sprint("     (" .. bp((i+j/xminstep())*fieldwidth()) .. "," .. bp(ymax()*fieldheight()) .. "-5/2) ;")
                end
            end
        end
    end
    if thirddata.diagramm.setup.ytick==true then
        -- Major ticks
        for i=ymin(),ymax(),ystep() do
            tex.sprint(" draw (" .. bp(xmin()*fieldwidth()) .. "," .. bp(i*fieldheight()) .. ") -- ")
            tex.sprint("      (" .. bp(xmin()*fieldwidth()) .. "+5," .. bp(i*fieldheight()) .. ") ;")
            tex.sprint(" draw (" .. bp(xmax()*fieldwidth()) .. "," .. bp(i*fieldheight()) .. ") -- ")
            tex.sprint("      (" .. bp(xmax()*fieldwidth()) .. "-5," .. bp(i*fieldheight()) .. ") ;")
        end
        -- Minor ticks
        for i=ymin(),ymax()-1,ystep() do
            for j=1,yminstep() do
                if thirddata.diagramm.axis.y.log==true then
                    -- logarithmische skalierung
                    tex.sprint(" draw (" .. bp(xmin()*fieldwidth()) .. "," .. bp((i+math.log10(j/yminstep()*10)*ystep())*fieldheight()) .. ") --   ")
                    tex.sprint("      (" .. bp(xmin()*fieldwidth()) .. "+5/2," .. bp((i+math.log10(j/yminstep()*10)*ystep())*fieldheight()) .. ") ;")
                    tex.sprint(" draw (" .. bp(xmax()*fieldwidth()) .. "," .. bp((i+math.log10(j/yminstep()*10)*ystep())*fieldheight()) .. ") --   ")
                    tex.sprint("      (" .. bp(xmax()*fieldwidth()) .. "-5/2," .. bp((i+math.log10(j/yminstep()*10)*ystep())*fieldheight()) .. ") ;")
                else
                    -- normale skalierung
                    tex.sprint(" draw (" .. bp(xmin()*fieldwidth()) .. "," .. bp((i+j*ystep()/yminstep())*fieldheight()) .. ") --   ")
                    tex.sprint("      (" .. bp(xmin()*fieldwidth()) .. "+5/2," .. bp((i+j*ystep()/yminstep())*fieldheight()) .. ") ;")
                    tex.sprint(" draw (" .. bp(xmax()*fieldwidth()) .. "," .. bp((i+j*ystep()/yminstep())*fieldheight()) .. ") --   ")
                    tex.sprint("      (" .. bp(xmax()*fieldwidth()) .. "-5/2," .. bp((i+j*ystep()/yminstep())*fieldheight()) .. ") ;")
                end
            end
        end
    end
end


-- Achsenbschriftung

function thirddata.diagramm.draw_label()
    local xaxislabel = thirddata.diagramm.axis.x.format
    local yaxislabel = thirddata.diagramm.axis.y.format
    -- Label für die X-Achse
    if thirddata.diagramm.setup.xaxis==true then
        for i=xmin(),xmax(),xstep() do
            tex.sprint(string.format('label.bot(textext("' .. xaxislabel .. '"),(%s,%s-5)) ;',i,bp(i*fieldwidth()),bp(ymin()*fieldheight())))
        end
    end
    -- Label für die Y-Achse
    if thirddata.diagramm.setup.yaxis==true then
        for i=ymin(),ymax(),ystep() do
            tex.sprint(string.format('label.lft(textext("' .. yaxislabel .. '"),(%s-5,%s)) ;',i,bp(xmin()*fieldwidth()),bp(i*fieldheight())))
        end
    end
end


-- Diagrammtypen

function thirddata.diagramm.draw_barchart()
    local fieldcount  = thirddata.diagramm.series_number()
    local fieldvalue  = fieldwidth() / (4 * fieldcount)
    for k,v in pairs(thirddata.diagramm.data) do
        for x,y in pairs(thirddata.diagramm.data[k]) do
            tex.sprint("fill unitsquare xscaled")
            tex.sprint("(" .. number.tobasepoints(3*fieldvalue) .. ")")
            tex.sprint(" yscaled ")
            tex.sprint("(" .. number.tobasepoints(thirddata.diagramm.data[k][x]["value"]*fieldheight()) .. ")")
            tex.sprint(" shifted ")
            tex.sprint("(" .. number.tobasepoints((x-1)*fieldwidth()+fieldvalue/2+(k-1)*fieldvalue*4) .. ",0)")
            tex.sprint("withcolor \\MPcolor{" .. thirddata.diagramm.data[k][x]["color"] .. "} ;")
        end
    end
end

function thirddata.diagramm.draw_piechart()
    local count       = 0
    local points      = thirddata.diagramm.points_()
    local alternative = thirddata.diagramm.setup.alternative
    tex.sprint("numeric OuterRing ;")
    tex.sprint("OuterRing := " .. number.tobasepoints(tex.dimen["outercircle"]).. " ;")
    tex.sprint("path p[], n[] ;")
    tex.sprint("p1 := fullcircle scaled OuterRing ;")
    for k,v in pairs(thirddata.diagramm.data) do
        for x,y in pairs(thirddata.diagramm.data[k]) do
            tex.sprint("p3 := (origin--(OuterRing,0)) rotated (" .. 360 / points * count .. ") ;")
            tex.sprint("p4 := (origin--(OuterRing,0)) rotated (" .. 360 / points * ( count + thirddata.diagramm.data[k][x]["value"] ) .. ") ;")
            tex.sprint("n1 := buildcycle(p3,p1,p4) ;")
            tex.sprint("fill n1 withcolor \\MPcolor{" .. thirddata.diagramm.data[k][x]["color"] .. "} ;")
            count = count + thirddata.diagramm.data[k][x]["value"]
        end
    end
    if alternative=="b" then
        -- Abtrennen der einzelnen Segmente durch eine Linie
        for k,v in pairs(thirddata.diagramm.data) do
            count = 0
            for x,y in pairs(thirddata.diagramm.data[k]) do
                tex.sprint("draw (origin--(OuterRing/2,0)) rotated (" .. 360 / points * count .. ") withpen pencircle scaled 4 withcolor white ;")
                count = count + thirddata.diagramm.data[k][x]["value"]
            end
        end
    end
end

function thirddata.diagramm.draw_ringchart()
    local count  = 0
    local points = thirddata.diagramm.points_()
    tex.sprint("numeric RingValues, InnerRing, OuterRing ;")
    tex.sprint("InnerRing := " .. number.tobasepoints(tex.dimen["innercircle"]) .. " ;")
    tex.sprint("OuterRing := " .. number.tobasepoints(tex.dimen["outercircle"]) .. " ;")
    tex.sprint("path p[], n[] ;")
    tex.sprint("p1 := fullcircle scaled OuterRing ;")
    tex.sprint("p2 := fullcircle scaled InnerRing ;")
    for k,v in pairs(thirddata.diagramm.data) do
        for x,y in pairs(thirddata.diagramm.data[k]) do
            tex.sprint("p3 := (origin--(OuterRing,0)) rotated (" .. 360 / points * count .. ") ;")
            tex.sprint("p4 := (origin--(OuterRing,0)) rotated (" .. 360 / points * ( count + thirddata.diagramm.data[k][x]["value"] ) .. ") ;")
            tex.sprint("n1 := buildcycle(p1,p4,p2,p3) ;")
            tex.sprint("fill n1 withcolor \\MPcolor{" .. thirddata.diagramm.data[k][x]["color"] .. "} ;")
            count = count + thirddata.diagramm.data[k][x]["value"]
        end
    end
    for i=1,points do
        tex.sprint("draw ((InnerRing/2,0)--(OuterRing/2,0)) rotated (" .. 360/points*i .. ") withcolor \\MPcolor{gray} ;")
    end
    tex.sprint("unfill p2 ;")
    tex.sprint("draw p1 withcolor \\MPcolor{darkgray} ;")
    tex.sprint("draw p2 withcolor \\MPcolor{darkgray} ;")
end

function thirddata.diagramm.draw_spiderchart()
    local count       = 0
    local anzahl      = thirddata.diagramm.points_anzahl()
    local max         = thirddata.diagramm.maxpoint_()
    local scale       = tex.dimen["outercircle"]/anzahl/1.61 -- soll 2 sein, wirkt aber zu klein
    local alternative = thirddata.diagramm.setup["alternative"]
    -- Hintergrund
    -- Linien vom Zentrum zu den Ecken
    for i=1,anzahl do
        tex.sprint("draw origin -- (" .. bp(max*scale) .. ",0) rotated (" .. 90 + (360/anzahl)*(i-1) .. ") withcolor \\MPcolor{darkgray} ;")
    end
    -- Linien für jeden Wert
    for j=1,max do
        if alternative=="a" then
            tex.sprint("draw (" .. bp(j*scale) .. ",0) rotated 90")
            for i=1,anzahl do
                tex.sprint("-- (" .. bp(j*scale) .. ",0) rotated (" .. 90 + (360/anzahl)*(i-1) .. ")")
            end
            tex.sprint("-- cycle withcolor \\MPcolor{darkgray} ;")
        elseif alternative=="b" then
            for i=1,anzahl do
                tex.sprint("draw ((" .. bp(j*scale) .. "," .. bp(-scale/8) .. ")")
                tex.sprint("-- (" .. bp(j*scale) .. "," .. bp(scale/8) .. "))")
                tex.sprint("rotated (" .. 90+(360/anzahl)*(i-1) .. ") withcolor \\MPcolor{darkgray} ;")
            end
        end
    end
    -- Datenlinien
    for k,v in pairs(thirddata.diagramm.data) do
        tex.sprint("draw")
        for x,y in pairs(thirddata.diagramm.data[k]) do
            tex.sprint("( (" .. bp(thirddata.diagramm.data[k][x]["value"]*scale) .. ",0) rotated " .. 90 + 360 / anzahl * count .. ") --")
            count = count + 1
        end
        tex.sprint("cycle withcolor \\MPcolor{" .. thirddata.diagramm.data[k][1]["color"] .. "} ;")
    end
end

function thirddata.diagramm.draw_linechart()
    local count       = 0
    local anzahl      = thirddata.diagramm.points_anzahl()
    for k,v in pairs(thirddata.diagramm.data) do
        count  = 0
        tex.sprint("draw")
        for x,y in pairs (thirddata.diagramm.data[k]) do
            count = count + 1
            if count==anzahl then
                tex.sprint("(" .. bp(x*fieldwidth()) .. "," .. bp(thirddata.diagramm.data[k][x]["value"]*fieldheight()) .. ") ")
            else
                tex.sprint("(" .. bp(x*fieldwidth()) .. "," .. bp(thirddata.diagramm.data[k][x]["value"]*fieldheight()) .. ") -- ")
            end
        end
        tex.sprint("withcolor \\MPcolor{" .. thirddata.diagramm.data[k][1]["color"] .. "} ; ")
    end
end

function thirddata.diagramm.draw_markerdata()
    for k,v in pairs(thirddata.diagramm.data) do
        for x,y in pairs (thirddata.diagramm.data[k]) do
            tex.sprint("fill fullcircle scaled 5")
            tex.sprint("shifted (" .. bp(x*fieldwidth()) .. "," .. bp(thirddata.diagramm.data[k][x]["value"]*fieldheight()) .. ")")
            tex.sprint("withcolor \\MPcolor{" .. thirddata.diagramm.data[k][1]["color"] .. "} ;")
        end
    end
end


-- Bounding Box

function thirddata.diagramm.draw_bb()
    local xmin        = thirddata.diagramm.range.x.min
    local xmax        = thirddata.diagramm.range.x.max
    local ymin        = thirddata.diagramm.range.y.min
    local ymax        = thirddata.diagramm.range.y.max
    -- tex.sprint("\\startMPdrawing")
    tex.sprint("z1 = (" .. bp(xmin*fieldwidth()) .. "," .. bp(ymin*fieldheight()) .. ") ;")
    tex.sprint("z2 = (" .. bp(xmax*fieldwidth()) .. "," .. bp(ymin*fieldheight()) .. ") ;")
    tex.sprint("z3 = (" .. bp(xmax*fieldwidth()) .. "," .. bp(ymax*fieldheight()) .. ") ;")
    tex.sprint("z4 = (" .. bp(xmin*fieldwidth()) .. "," .. bp(ymax*fieldheight()) .. ") ;")
    tex.sprint("setbounds currentpicture to z1--z2--z3--z4--cycle ;")
    -- tex.sprint("\\stopMPdrawing")
end

-- Aufruf der Zeichenfunktionen vom TeX-Interface

--[[
function thirddata.diagramm.drawchart(chart)
    if chart=="barchart" then
        thirddata.diagramm.draw_barchart()
    elseif chart=="piechart" then
        thirddata.diagramm.draw_piechart()
    elseif chart=="ringchart" then
        thirddata.diagramm.draw_ringchart()
    elseif chart=="spiderchart" then
        thirddata.diagramm.draw_spiderchart()
    elseif chart=="linechart" then
        thirddata.diagramm.draw_linechart()
    else
        print("Chartstyle not available")
    end
end
--]]

thirddata.diagramm.chartstyles =
    {
        barchart    = thirddata.diagramm.draw_barchart   ,
        piechart    = thirddata.diagramm.draw_piechart   ,
        ringchart   = thirddata.diagramm.draw_ringchart  ,
        spiderchart = thirddata.diagramm.draw_spiderchart,
        linechart   = thirddata.diagramm.draw_linechart  ,
        markerdata  = thirddata.diagramm.draw_markerdata ,
    }

function thirddata.diagramm.drawchart(chart)
    if thirddata.diagramm.chartstyles[chart]==nil then
        print("Undefined chartstyle")
    else
        thirddata.diagramm.draw_grid()
        thirddata.diagramm.chartstyles[chart]()
        thirddata.diagramm.draw_tick()
        thirddata.diagramm.draw_axis()
        thirddata.diagramm.draw_label()
        -- thirddata.diagramm.draw_bb()
    end
end

end
