--function make_window()
actorNames={}
 actors={{}}
-- attributes lua table for refrence


resources={"Income","Assets","Cash","Securities","Property"}
attributes={"Name","Occupation","CodeName","Sex","Age","STR","CON","SIZ","INT","POW","DEX","APP","EDU","SAN","HP","Magic","Luck","Know","Move","Armor","DamageBonus"}
--cocView lua function to view character data

function cocView(charTable)
charsheet=""
if charTable.Name ==nil then return charsheet end
charsheet=charTable.Name.."\t"
NameInput:value(charTable.Name)
if charTable.CodeName ~=nil then
charsheet=charsheet.."Codename:"..charTable.CodeName.."\n\n"
end
charsheet=charsheet..charTable.Occupation[1][1].."\t"
csex=charTable.SEX
cjob=charTable.Occupation[1][1]
cage=charTable.AGE
cout=cjob
Occupation:value(cout)
charsheet=charsheet..charTable.SEX.."\t"
charsheet=charsheet.."Age:"..charTable.AGE.."\n\n"
cc=0
ic=0
	for i=6,table.getn(attributes),1 do
	ic=ic+1
	cc=cc+1
		if cc==4 then 
		del="\n" 
		cc=0
		else
		del="   "
		end		
	if ic>=15 then 
	del="\n"
	end
	a=attributes[i]
	b =charTable[a]
	charsheet=charsheet..a.."  "..b..del
	end
	
	
	
	for i=6,#attributes,1 do
	a=attributes[i]
	b =charTable[a]
	if b~=nil then
	DetailsBrowser:add(a)
	ValuesBrowser:add(b)
	end
	end
	DetailsBrowser:add("Age")
	ValuesBrowser:add(charTable.AGE)
	DetailsBrowser:add("Sex")
	ValuesBrowser:add(charTable.SEX)
	
	
charsheet=charsheet.."\n"
	for i=1,table.getn(charTable.skills),1 do
	a=charTable.skills[i][1]
	b = charTable.skills[i][2]
	SkillsBrowser:add(a)
	SkillsValuesBrowser:add(b)
	charsheet=charsheet..a.."  "..b.."\n"
	end	
	if charTable.equipment ~= nil then
charsheet=charsheet.."\n"
	gear=charTable.equipment
	for i,v in pairs(gear) do 
	a=v[1]
	b=v[2] 
	
	charsheet=charsheet..a.."  "..b.."\n"
	end
	end
return charsheet	
end --end cocview
-- viewactor
function viewactor(n)
print("\n"..cocView(actors[n]))

end
--editorprint code -----------------------


function editorPrint(...)
	local str=""
	local i=1
	while arg[i]~= nil do
		if str=="" then
			str=tostring(arg[i])
		else
			str=str.."	"..tostring(arg[i])
		end
		i=i+1
	end
	local l_offset=#editor_buf:text()
	editor:insert_position(l_offset)
	editor:insert(str.."\n")
	editor:show_insert_position()
	editor:textfont(4)
	editor:textsize(11)
end
--editorB print code -----------------------


function editorPrintB(...)

	local str=""
	local i=1
	while arg[i]~= nil do
		if str=="" then
			str=tostring(arg[i])
		else
			str=str.."	"..tostring(arg[i])
		end
		i=i+1
	end
	local l_offset=#editor_bufB:text()
	editorB:insert_position(l_offset)
	editorB:insert(str.."\n")
	editorB:show_insert_position()
	editorB:textfont(4)
	editorB:textsize(11)
end
dofile("/ig3d_mac_xcode/Data/Fluid/CocCharacters/Cthulhuskills.lua")
-- viewskills
function viewskills(w)
editor_buf:text("")
charTable ={{}}
n=w:value()
a=CharacterBrowser:value()+1
charTable = actors[a]
b=charTable.skills[n][1]
f=""
for i,v in pairs(cthulhuskills) do

if v[1] == b then
c=v[2]
d=v[3]
if d~=nil then

nn=0
nc=0
aa=""

for ii in string.gfind(d,".") do
nn=nn+1 
aa=aa..ii
nc=nc+1
	if nc>=24 then 
	if ii == " " then
	aa=aa.."\n"
	nc=0
	end
	end
end
editorPrint(b.."   "..c)
if aa ~= "" then editorPrint("\n"..aa) end
else
editorPrint(b.." "..c.."\n")
end
end
end


	
end
function hasSkillDescription(b)


for i =1,#cthulhuskills,1 do
c=cthulhuskills[i][1]
c=cthulhuskills[i]
ca=c[1]
cb=c[2]
cc=c[3]
	if ca == b then
	if cc~= nil then
		return true
		end
		end
end
return false
end
dofile("/ig3d_mac_xcode/Data/Fluid/CocCharacters/Cthulhu1920OCC.lua")
occSkills={}
for n=1,#CthulhuOccupations,1 do
c=CthulhuOccupations[n]
	for i,v in pairs(c) do 
	if hasSkillDescription(v)==true then
	table.insert(occSkills,v) 
	end
	end
end


function viewoccupation(w)
occSkills={}
n=w:value()
OccSkillsBrowser:clear()
c=CthulhuOccupations[n]
for i,v in pairs(c) do 
if hasSkillDescription(v)==true then
OccSkillsBrowser:add(v)
table.insert(occSkills,v) 
end
end
OccSkillsBrowser:redraw()
return occSkills
end
function viewskillsB(w)
OccupationsList:make_current();
editor_bufB:text("")
n=w:value()
o=""
b=occSkills[n]
for i =1,#cthulhuskills,1 do
c=cthulhuskills[i][1]
c=cthulhuskills[i]
ca=c[1]
cb=c[2]
cc=c[3]
		if ca == b then

		if cc~= nil then
		o=b.."\n"..cc

		nn=0
		nc=0
		aa=""

	for ii in string.gfind(cc,".") do
	nn=nn+1 
	aa=aa..ii
	nc=nc+1
	if nc>=(editorB:w()/10) then 
	if ii == " " then
	aa=aa.."\n"
	nc=0
	end
	end
	end
--editorPrintB(ca.."   "..cc)
 if aa ~= "" then editorPrintB("\n"..aa) end

	--else
		--editorPrintB(cb.." "..cc.."\n")
		end
		end
end

		

	


return o

end
function init_viewer()


OccupationsBrowser:clear()
for ii=1,#CthulhuOccupations,1 do
c=CthulhuOccupations[ii][1]
OccupationsBrowser:add(c) 
--for i,v in pairs(c) do end
end
OccupationsBrowser:redraw()

end
do OccupationsList= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "OCC")
OccupationsList:label(gLabelTable[#gLabelTable])
OccupationsList:resize(376,210,587,358)
Fl_Group:current():resizable(OccupationsList)
--OccupationsList:show()
do editor= fltk:Fl_Text_Editor(0,0,0,0,"")
editor:resize(305,8,265,21)
editor:align(161)
editor:when(1)
editor:textfont(4)
editor:textsize(12)
--unknown attribute: hide
--unknown attribute: deactivate
end

do editorB= fltk:Fl_Text_Editor(0,0,0,0,"")
editorB:resize(305,13,270,335)
editorB:align(161)
editorB:when(1)
editorB:textfont(4)
editorB:textsize(12)
Fl_Group:current():resizable(editorB)
end

do OccupationsBrowser= fltk:Fl_Browser(0,0,0,0,"")
OccupationsBrowser:callback(viewoccupation)
OccupationsBrowser:resize(5,13,195,341)
OccupationsBrowser:type(2)
OccupationsBrowser:labelsize(11)
OccupationsBrowser:align(5)
OccupationsBrowser:textsize(11)
end

do OccSkillsBrowser= fltk:Fl_Browser(0,0,0,0,"")
OccSkillsBrowser:callback(viewskillsB)
OccSkillsBrowser:resize(205,11,95,337)
OccSkillsBrowser:type(2)
OccSkillsBrowser:labelsize(11)
OccSkillsBrowser:align(5)
OccSkillsBrowser:textsize(11)
end
end
OccupationsList:show()

OccupationsList:show();
editor_buf = fltk:Fl_Text_Buffer();
editor:buffer( editor_buf );

editor_bufB = fltk:Fl_Text_Buffer();
editorB:buffer( editor_bufB );
init_viewer()
--end
Fl:run()
