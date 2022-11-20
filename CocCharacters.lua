--function make_window()
actorNames={}
 actors={{}}
-- attributes lua table for refrence

gameroot=lfs.currentdir().."/"
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
-- ListActors
function listactors()
CharacterBrowser:clear()
for i,v in pairs(actorNames) do CharacterBrowser:add(v) end
end
function openScript(tFile)


if changed then

	if not closeScript() then

		return false

	end

end
if tFile ==nil then

fileName = fltk.fl_file_chooser("Choose a script to open:", "Lua Files (*.{lua, ig3d})", nil, nil)
else
fileName = gameroot..tFile
end

if fileName~= nil then

print(fileName)
	local f=io.open(fileName, "r")
	local tText=f:read("*a")
dofile(fileName)
listactors()
	--editorPrint(tText)

	f:close()

	closer:activate()

	--output1:value(fileName)

else

	return false

end
return true
end





function openScriptC()
closeScript()
	openScript()

end
-- script editor functions
function runScriptC()

	local str=editor_buf:text()	

	local code,error=loadstring(str)
	

	if code==nil then

		fltk.fl_message("The script you were attempting to run contains errors:\n"..error)

	else

		code()

	end

end







function saveScript()

	if fileName == nil then

		fileName = fltk.fl_file_chooser("Please enter the filename:", "Lua Files (*.{lua, ig3d})", nil, nil)

		if fileName == nil then

			return false

		else

			--output1:value(fileName)

			closer:activate()

		end

	end

	

	local f=io.open(fileName, "w")

	f:write(editor_buf:text())

	f:close()

	changed=false

	saver:deactivate()

	return true

end



function saveScriptC()

	saveScript()

end









function editorChangedContents(w)
changed=true
saver:activate()
end





function closeScript()

	if changed then

		local r=fltk.fl_choice("Do you want to save your changes first?", "No", "Yes", "Cancel")

		if r == 2 then

			return false

		end

		

		if r == 1 then

			if not saveScript() then

				return false

			end

		end

	end

		

	editor_buf:text("")

	--output1:value("")

	changed=false

	fileName=nil

	closer:deactivate()

	saver:deactivate()

	return true

end



function closeScriptC()

	closeScript()

end





function newScript()

	if fileName~= nil or changed then

		if not closeScript() then

			return false

		end

	end

end



function newScriptC()

	newScript()

end



changed=false

fileName=nil



---------------------------------------------------------------------
-- viewcharacter
function viewcharacter(w)
if w:value() ~= nil  then
local n = w:value()+1
if n >= #actors+1 then n=#actors+1 end

print(n,w:text(n))
CallOfCthulhuCDetails:make_current();
editor_buf:text("")
DetailsBrowser:clear()
ValuesBrowser:clear()
Occupation:value("")
SkillsBrowser:clear()
SkillsValuesBrowser:clear()
	
CallOfCthulhuCDetails:redraw()

editorPrint(cocView(actors[n]))
end
end
-- CallOfCthulhuCDetailsClose
function CallOfCthulhuCDetailsClose()
CallOfCthulhuCDetails:hide()
CallOfCthulhuCDetails=nil
CharactersList:hide()
CharactersList=nil
end
--characters
--dofile("/cocharacters.lua")
-- Antoin Dobson MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
AntoinDobson={
Name="Antoin Dobson" , SEX="Male" , AGE="21 " , 

STR=8 , CON=7 , SIZ=11 , INT=15 ,POW=14 , 
DEX=9 , APP=13 , EDU=15 , SAN=70 , HP=9 , 
Magic=14 , Idea=75 , Luck=70 , Know=75 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=604  , Income=1208 ,    Assets= 6040  ,    Securities=604 ,
Property= 4832 ,    
}; --end AntoinDobson base attributes

-- occupation
AntoinDobson.Occupation={{"Agency Detective" , "Immunity to sanity losses from corpses, injuries, etc." }, }
AntoinDobson.skills ={
{"Bargain"  ,20} ,
{"Fast Talk"  ,50} ,
{"Fist/Punch"  ,50} ,
{"Grapple"  ,50} ,
{"Handgun"  ,50} ,
{"Hide"  ,20} ,
{"Law"  ,50} ,
{"Library Use"  ,50} ,
{"Persuade"  ,35} ,
{"Psychology"  ,50} ,
{"Sneak"  ,30} ,
{"Track"  ,30} ,
}; -- end local skills registry
AntoinDobson.contacts={
"Police" ,
"Previous Clients" ,
};-- end contacts

table.insert(actorNames,"AntoinDobson")
table.insert(actors,AntoinDobson)

--  END Antoin Dobson



-- Anthony Antiquarian MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
AnthonyAntiquarian={
Name="Anthony Antiquarian" , SEX="Male" , AGE="42 " , 

STR=15 , CON=9 , SIZ=15 , INT=12 ,POW=13 , 
DEX=10 , APP=8 , EDU=15 , SAN=65 , HP=12 , 
Magic=13 , Idea=60 , Luck=65 , Know=75 ,
Move=8  , Armor=0 , DamageBonus="+1D4" ,
-- money
Cash=1250  , Income=2500 ,    Assets= 12500  ,    Securities=1250 ,
Property= 10000 ,    
}; --end AnthonyAntiquarian base attributes

-- occupation
AnthonyAntiquarian.Occupation={{"Antiquarian" , ""}, }
AnthonyAntiquarian.skills ={
{"Antiques"  ,40} ,
{"Art"  ,40} ,
{"Bargain"  ,80} ,
{"Craft"  ,50} ,
{"English"  ,50} ,
{"History"  ,50} ,
{"Library Use"  ,27} ,
{"Spot Hidden"  ,50} ,
}; -- end local skills registry

table.insert(actorNames,"AnthonyAntiquarian")
table.insert(actors,AnthonyAntiquarian)

--  END Anthony Antiquarian



-- Boris VonBotan MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
BorisVonBotan={
Name="Boris VonBotan" , SEX="Male" , AGE="46 " , 

STR=13 , CON=16 , SIZ=12 , INT=13 ,POW=13 , 
DEX=12 , APP=14 , EDU=13 , SAN=65 , HP=14 , 
Magic=13 , Idea=65 , Luck=65 , Know=65 ,
Move=8  , Armor=0 , DamageBonus="+1D4" ,
-- money
Cash=6934  , Income=13867 ,    Assets= 69336  ,    Securities=6934 ,
Property= 55468 ,    
}; --end BorisVonBotan base attributes

-- occupation
BorisVonBotan.Occupation={{"Researcher" , ""}, }
BorisVonBotan.skills ={
{"Biology"  ,60} ,
{"Spot Hidden"  ,50} ,
{"Rifle"  ,39} ,
{"Natural History"  ,40} ,
{"History"  ,47} ,
{"Geology"  ,29} ,
{"First Aid"  ,50} ,
{"Credit Rating"  ,66} ,
{"English"  ,60} ,
{"Library Use"  ,50} ,
{"Pharmacy"  ,73} ,
{"Psychology"  ,62} ,
}; -- end local skills registry
BorisVonBotan.contacts={
"Scholars" ,
"Local Labs" ,
"Libraries" ,
"Universities" ,
};-- end contacts

table.insert(actorNames,"BorisVonBotan")
table.insert(actors,BorisVonBotan)

--  END Boris VonBotan



-- Cyhthia Sudol MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
CyhthiaSudol={
Name="Cyhthia Sudol" , SEX="Female" , AGE="20 " , 

STR=9 , CON=11 , SIZ=11 , INT=18 ,POW=8 , 
DEX=12 , APP=16 , EDU=16 , SAN=40 , HP=11 , 
Magic=8 , Idea=90 , Luck=40 , Know=80 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=2058  , Income=4116 ,    Assets= 20580  ,    Securities=2058 ,
Property= 16464 ,    
}; --end CyhthiaSudol base attributes

-- occupation
CyhthiaSudol.Occupation={{"Columnist" , ""}, }
CyhthiaSudol.skills ={
{"Art"  ,30} ,
{"Spanish"  ,8} ,
{"Latin"  ,10} ,
{"Spot Hidden"  ,36} ,
{"English"  ,30} ,
{"Italian"  ,12} ,
{"Listen"  ,40} ,
{"Law"  ,10} ,
{"Pick Pocket"  ,10} ,
{"Art History"  ,30} ,
{"Shorthand"  ,30} ,
{"Bargain"  ,60} ,
{"Credit Rating"  ,80} ,
{"Fast Talk"  ,80} ,
{"German"  ,60} ,
{"Persuade"  ,70} ,
{"Psychology"  ,70} ,
}; -- end local skills registry
CyhthiaSudol.contacts={
"News Industry" ,
};-- end contacts

table.insert(actorNames,"CyhthiaSudol")
table.insert(actors,CyhthiaSudol)

--  END Cyhthia Sudol



-- Dr Grover Walnut MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
DrGroverWalnut={
Name="Dr Grover Walnut" , SEX="Female" , AGE="20 " , 

STR=13 , CON=15 , SIZ=17 , INT=11 ,POW=12 , 
DEX=12 , APP=11 , EDU=14 , SAN=60 , HP=16 , 
Magic=12 , Idea=55 , Luck=60 , Know=70 ,
Move=8  , Armor=0 , DamageBonus="+1D4" ,
-- money
Cash=352  , Income=704 ,    Assets= 3520  ,    Securities=352 ,
Property= 2816 ,    
}; --end DrGroverWalnut base attributes

-- occupation
DrGroverWalnut.Occupation={{"Forensic Specialist" , "Immune to sanity losses due to viewing most muder or injury scenes." }, {"Doctor of Medicine" , ""}, }
DrGroverWalnut.skills ={
{"Biology"  ,40} ,
{"Chemistry"  ,40} ,
{"Credit Rating"  ,30} ,
{"First Aid"  ,55} ,
{"Latin"  ,40} ,
{"Law"  ,5} ,
{"Medicine"  ,45} ,
{"Pharmacy"  ,40} ,
{"Photography"  ,20} ,
{"Psychoanalysis"  ,10} ,
{"Psychology"  ,10} ,
{"Sports Medicine"  ,21} ,
{"Spot Hidden"  ,25} ,
}; -- end local skills registry
DrGroverWalnut.contacts={
"Local Labs" ,
"Law Enforcement" ,
"Chemical Suppliers" ,
};-- end contacts

table.insert(actorNames,"DrGroverWalnut")
table.insert(actors,DrGroverWalnut)

--  END Dr Grover Walnut



-- Jacob Isaacs MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
JacobIsaacs={
Name="Jacob Isaacs" , SEX="Male" , AGE="23 " , 

STR=4 , CON=10 , SIZ=16 , INT=13 ,POW=9 , 
DEX=9 , APP=6 , EDU=17 , SAN=45 , HP=13 , 
Magic=9 , Idea=65 , Luck=45 , Know=85 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=3750  , Income=7500 ,    Assets= 37500  ,    Securities=3750 ,
Property= 30000 ,    
}; --end JacobIsaacs base attributes

-- occupation
JacobIsaacs.Occupation={{"Farmer/Forester" , ""}, }
JacobIsaacs.skills ={
{"Craft"  ,60} ,
{"Electrical Repair"  ,50} ,
{"Biology"  ,30} ,
{"Drive Auto"  ,41} ,
{"Shotgun"  ,45} ,
{"Rifle"  ,40} ,
{"Listen"  ,30} ,
{"Drive Horses"  ,40} ,
{"Club"  ,40} ,
{"First Aid"  ,70} ,
{"Mechanical Repair"  ,60} ,
{"Natural History"  ,50} ,
{"Axe"  ,40} ,
{"Operate Heavy Machine"  ,50} ,
{"Psychology"  ,50} ,
{"Track"  ,41} ,
}; -- end local skills registry

table.insert(actorNames,"JacobIsaacs")
table.insert(actors,JacobIsaacs)

--  END Jacob Isaacs



-- Kendall Spalding MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
KendallSpalding={
Name="Kendall Spalding" , SEX="Male" , AGE="32 " , 

STR=13 , CON=6 , SIZ=16 , INT=16 ,POW=8 , 
DEX=9 , APP=13 , EDU=16 , SAN=40 , HP=11 , 
Magic=8 , Idea=80 , Luck=40 , Know=80 ,
Move=8  , Armor=0 , DamageBonus="+1D4" ,
-- money
Cash=3750  , Income=7500 ,    Assets= 37500  ,    Securities=3750 ,
Property= 30000 ,    
}; --end KendallSpalding base attributes

-- occupation
KendallSpalding.Occupation={{"Farmer/Forester" , ""}, }
KendallSpalding.skills ={
{"Craft"  ,60} ,
{"Electrical Repair"  ,50} ,
{"Biology"  ,30} ,
{"Drive Auto"  ,41} ,
{"Shotgun"  ,45} ,
{"Rifle"  ,40} ,
{"Listen"  ,40} ,
{"Drive Horses"  ,40} ,
{"Club"  ,40} ,
{"First Aid"  ,70} ,
{"Mechanical Repair"  ,60} ,
{"Natural History"  ,50} ,
{"Axe"  ,60} ,
{"Operate Heavy Machine"  ,50} ,
{"Psychology"  ,30} ,
{"Track"  ,41} ,
}; -- end local skills registry

table.insert(actorNames,"KendallSpalding")
table.insert(actors,KendallSpalding)

--  END Kendall Spalding



-- Philip Forenzo MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
PhilipForenzo={
Name="Philip Forenzo" , SEX="Male" , AGE="41 " , 

STR=8 , CON=12 , SIZ=15 , INT=14 ,POW=9 , 
DEX=15 , APP=9 , EDU=21 , SAN=45 , HP=14 , 
Magic=9 , Idea=70 , Luck=45 , Know=99 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=1070  , Income=2140 ,    Assets= 10700  ,    Securities=1070 ,
Property= 8560 ,    
}; --end PhilipForenzo base attributes

-- occupation
PhilipForenzo.Occupation={{"Forensic Specialist" , "Immune to sanity losses due to viewing most muder or injury scenes." }, }
PhilipForenzo.skills ={
{"Biology"  ,80} ,
{"Chemistry"  ,62} ,
{"Law"  ,50} ,
{"Medicine"  ,62} ,
{"Pharmacy"  ,64} ,
{"Photography"  ,60} ,
{"Spot Hidden"  ,90} ,
{"Anthropology"  ,6} ,
{"Archery"  ,20} ,
{"Electrical Repair"  ,20} ,
{"Psychology"  ,10} ,
{"Psychoanalysis"  ,10} ,
{"Physics"  ,20} ,
{"Latin"  ,20} ,
{"Drawing"  ,20} ,
{"Mechanical Repair"  ,30} ,
{"Typing"  ,4} ,
{"Forensic Surgery"  ,50} ,
}; -- end local skills registry
PhilipForenzo.contacts={
"Local Labs" ,
"Law Enforcement" ,
"Chemical Suppliers" ,
};-- end contacts

table.insert(actorNames,"PhilipForenzo")
table.insert(actors,PhilipForenzo)

--  END Philip Forenzo



-- Inspector Contraption MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
InspectorContraption={
Name="Inspector Contraption" , SEX="Male" , AGE="35 " , 

STR=9 , CON=18 , SIZ=9 , INT=15 ,POW=17 , 
DEX=7 , APP=9 , EDU=16 , SAN=85 , HP=14 , 
Magic=17 , Idea=75 , Luck=85 , Know=80 ,
Move=12  , Armor=0 , DamageBonus="none" ,
-- money
Cash=1750  , Income=3500 ,    Assets= 17500  ,    Securities=1750 ,
Property= 14000 ,    
}; --end InspectorContraption base attributes

-- occupation
InspectorContraption.Occupation={{"Police Detective" , ""}, }
InspectorContraption.skills ={
{"Fast Talk"  ,60} ,
{"Law"  ,15} ,
{"Listen"  ,60} ,
{"Mechanical Repair"  ,80} ,
{"Persuade"  ,60} ,
{"Psychology"  ,10} ,
{"Spot Hidden"  ,80} ,
{"Bargain"  ,60} ,
{"Archery"  ,20} ,
{"Artillery"  ,10} ,
{"Axe"  ,25} ,
{"Credit Rating"  ,30} ,
{"Comedy"  ,10} ,
{"Locksmith"  ,22} ,
{"Jump"  ,50} ,
{"Grapple"  ,30} ,
{"Electrical Repair"  ,15} ,
{"Handgun"  ,40} ,
{"Flamethrower"  ,10} ,
{"Juggling"  ,15} ,
{"Fist/Punch"  ,60} ,
{"Climb"  ,60} ,
}; -- end local skills registry

table.insert(actorNames,"InspectorContraption")
table.insert(actors,InspectorContraption)

--  END Inspector Contraption



-- Eva Purselane MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
EvaPurselane={
Name="Eva Purselane" , SEX="Female" , AGE="19 " , 

STR=13 , CON=11 , SIZ=8 , INT=13 ,POW=8 , 
DEX=9 , APP=14 , EDU=11 , SAN=40 , HP=10 , 
Magic=8 , Idea=65 , Luck=40 , Know=55 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=5000  , Income=10000 ,    Assets= 50000  ,    Securities=5000 ,
Property= 40000 ,    
}; --end EvaPurselane base attributes

-- occupation
EvaPurselane.Occupation={{"Journalist" , ""}, }
EvaPurselane.skills ={
{"English"  ,55} ,
{"Occult"  ,20} ,
{"Fast Talk"  ,40} ,
{"History"  ,30} ,
{"Library Use"  ,31} ,
{"Persuade"  ,50} ,
{"Photography"  ,50} ,
{"Psychology"  ,50} ,
{"Shorthand"  ,50} ,
{"Art"  ,20} ,
{"Literature History"  ,15} ,
{"Art History"  ,10} ,
{"Natural History"  ,20} ,
{"Craft"  ,20} ,
{"Spot Hidden"  ,40} ,
{"Printing History"  ,9} ,
{"First Aid"  ,40} ,
{"Bookbinding"  ,20} ,
}; -- end local skills registry
EvaPurselane.equipment ={
{"Handle Bag (8 lbs.)", "","7.45"},
{"Suitcase (15 lbs.)", "","9.95"},
{"Velour Coat with Fur Trim", "","39.75"},
{"Snug Velour Hat", "","4.44"},
{"Chic Designer Dress", "","90"},
{"Worsted Wool Sweater", "","9.48"},
{"Leather One-strap Slippers", "","3.69"},
{"Silk Hose (3 pairs)", "","2.25"},
{"Travelair 2000 Biplane", "","3,000"},
{"Taxi Rate (per mile)", "","0.05"},
{"Train Fare (500 miles)", "","6"},
{"Train Fare (100 miles)", "","3"},
{"Tool Outfit (20 tools)", "","12.9"},
{"Photo Printing (per picture)", "","0.05"},
{"Photography Case", "","1.8"},
{"Film, 6 exposures", "","0.5"},
{"Folding Pocket Camera", "","16.15"},
{"Film, 24 exposures", "","0.38"},
{"Film Development (per picture)", "","0.09"},
{"Developer Kit", "","4.95"},
{"Box Camera", "","2.29"},
{"Women's Toilet Set (15 pieces)", "","22.95"},
{"Writing Tablet", "","0.2"},
{"Wrist Watch", "","5.95"},
{"Wire Recorder", "","129.95"},
{"Unabridged Dictionary", "","6.75"},
{"Umbrella", "","1.79"},
{"Self-filling Fountain Pen", "","1.25"},
{"10-volume Encyclopedia", "","49"},
{"Playing Cards", "","0.75"},
{"Ouija Board", "","0.95"},
{"Dictaphone", "","39.95"},
{"Good Hotel (per night)", "","9"},
{"Console Radio Receiver", "","49.95"},
{"Postage (1 oz.)", "","0.03"},
{"Telegram (12 words)", "","0.25"},
{"Telegram (International, per word)", "","1.25"},
{"Newspaper", "","0.05"},
{"Desk Phone (bridging type)", "","15.75"},
{"Phonograph Records", "","0.39"},
{"Movie Ticket, Seated", "","0.15"},
{"Cabinet Phonograph", "","45"},
{"House (rent per year)", "","1,000"},
{"Wardrobe (95 lbs.)", "","41.95"},
{"Total Equipment Cost"," 4,638.43"}
}; --end equipement
EvaPurselane.contacts={
"District Attorneys" ,
"Film Industry" ,
"Artists" ,
"Medical Professionals" ,
"Universities" ,
"Publishing Industry" ,
"Publishers" ,
"News Industry" ,
"Magazine Industry" ,
"Local Government" ,
"Law Enforcement" ,
};-- end contacts

table.insert(actorNames,"EvaPurselane")
table.insert(actors,EvaPurselane)

--  END Eva Purselane



-- Nichole Contraption MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
NicholeContraption={
Name="Nichole Contraption" , SEX="Female" , AGE="20 " , 

STR=9 , CON=16 , SIZ=8 , INT=18 ,POW=15 , 
DEX=15 , APP=12 , EDU=14 , SAN=75 , HP=12 , 
Magic=15 , Idea=90 , Luck=75 , Know=70 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=219  , Income=438 ,    Assets= 2190  ,    Securities=219 ,
Property= 1752 ,    
}; --end NicholeContraption base attributes

-- occupation
NicholeContraption.Occupation={{"Student/Intern" , ""}, }
NicholeContraption.skills ={
{"Biology"  ,70} ,
{"First Aid"  ,40} ,
{"Geology"  ,10} ,
{"Chemistry"  ,70} ,
{"English"  ,75} ,
{"Library Use"  ,90} ,
{"Pharmacy"  ,73} ,
{"Hide"  ,20} ,
{"Climb"  ,50} ,
{"Jump"  ,50} ,
{"Kick"  ,50} ,
{"Electrical Repair"  ,20} ,
{"Medicine"  ,15} ,
{"Drive Auto"  ,30} ,
{"Pilot Aircraft"  ,10} ,
{"Pilot Boat"  ,10} ,
{"Mechanical Repair"  ,26} ,
{"Persuade"  ,20} ,
{"Occult"  ,10} ,
{"Latin"  ,10} ,
{"Japanese"  ,10} ,
{"Ancient Mayan"  ,10} ,
}; -- end local skills registry
NicholeContraption.contacts={
"Scholars" ,
"Libraries" ,
"Universities" ,
"Local Labs" ,
};-- end contacts

table.insert(actorNames,"NicholeContraption")
table.insert(actors,NicholeContraption)

--  END Nichole Contraption



-- Bentley Garett MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
BentleyGarett={
Name="Bentley Garett" , SEX="Male" , AGE="44 " , 

STR=13 , CON=6 , SIZ=16 , INT=16 ,POW=8 , 
DEX=9 , APP=13 , EDU=18 , SAN=40 , HP=11 , 
Magic=8 , Idea=80 , Luck=40 , Know=90 ,
Move=8  , Armor=0 , DamageBonus="+1D4" ,
-- money
Cash=2750  , Income=5500 ,    Assets= 27500  ,    Securities=2750 ,
Property= 22000 ,    
}; --end BentleyGarett base attributes

-- occupation
BentleyGarett.Occupation={{"Parapsychologist" , ""}, }
BentleyGarett.skills ={
{"Anthropology"  ,60} ,
{"Archaeology"  ,60} ,
{"Sword"  ,20} ,
{"Handgun"  ,30} ,
{"Antiques"  ,30} ,
{"Drive Auto"  ,30} ,
{"Drive Horses"  ,30} ,
{"Printing History"  ,14} ,
{"English"  ,50} ,
{"History"  ,80} ,
{"Library Use"  ,70} ,
{"Listen"  ,60} ,
{"Occult"  ,58} ,
{"Architectural History"  ,20} ,
{"Navigate"  ,30} ,
{"Geology"  ,21} ,
{"Art History"  ,5} ,
{"Photography"  ,30} ,
{"Psychology"  ,20} ,
}; -- end local skills registry

table.insert(actorNames,"BentleyGarett")
table.insert(actors,BentleyGarett)

--  END Bentley Garett
--characters2

-- Nichole Contraption MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
NicholeContraption={
Name="Nichole Contraption" , SEX="Female" , AGE="20 " , 

STR=9 , CON=16 , SIZ=8 , INT=18 ,POW=15 , 
DEX=15 , APP=12 , EDU=14 , SAN=75 , HP=12 , 
Magic=15 , Idea=90 , Luck=75 , Know=70 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=219  , Income=438 ,    Assets= 2190  ,    Securities=219 ,
Property= 1752 ,    
}; --end NicholeContraption base attributes

-- occupation
NicholeContraption.Occupation={{"Student/Intern" , ""}, }
NicholeContraption.skills ={
{"Biology"  ,70} ,
{"First Aid"  ,40} ,
{"Geology"  ,10} ,
{"Chemistry"  ,70} ,
{"English"  ,75} ,
{"Library Use"  ,90} ,
{"Pharmacy"  ,73} ,
{"Hide"  ,20} ,
{"Climb"  ,50} ,
{"Jump"  ,50} ,
{"Kick"  ,50} ,
{"Electrical Repair"  ,20} ,
{"Medicine"  ,15} ,
{"Drive Auto"  ,30} ,
{"Pilot Aircraft"  ,10} ,
{"Pilot Boat"  ,10} ,
{"Mechanical Repair"  ,26} ,
{"Persuade"  ,20} ,
{"Occult"  ,10} ,
{"Latin"  ,10} ,
{"Japanese"  ,10} ,
{"Ancient Mayan"  ,10} ,
}; -- end local skills registry
NicholeContraption.contacts={
"Scholars" ,
"Libraries" ,
"Universities" ,
"Local Labs" ,
};-- end contacts

table.insert(actorNames,"NicholeContraption")
table.insert(actors,NicholeContraption)

--  END Nichole Contraption

-- Bentley Garett MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
BentleyGarett={
Name="Bentley Garett" , SEX="Male" , AGE="44 " , 

STR=13 , CON=6 , SIZ=16 , INT=16 ,POW=8 , 
DEX=9 , APP=13 , EDU=18 , SAN=40 , HP=11 , 
Magic=8 , Idea=80 , Luck=40 , Know=90 ,
Move=8  , Armor=0 , DamageBonus="+1D4" ,
-- money
Cash=2750  , Income=5500 ,    Assets= 27500  ,    Securities=2750 ,
Property= 22000 ,    
}; --end BentleyGarett base attributes

-- occupation
BentleyGarett.Occupation={{"Parapsychologist" , ""}, }
BentleyGarett.skills ={
{"Anthropology"  ,60} ,
{"Archaeology"  ,60} ,
{"Sword"  ,20} ,
{"Handgun"  ,30} ,
{"Antiques"  ,30} ,
{"Drive Auto"  ,30} ,
{"Drive Horses"  ,30} ,
{"Printing History"  ,14} ,
{"English"  ,50} ,
{"History"  ,80} ,
{"Library Use"  ,70} ,
{"Listen"  ,60} ,
{"Occult"  ,58} ,
{"Architectural History"  ,20} ,
{"Navigate"  ,30} ,
{"Geology"  ,21} ,
{"Art History"  ,5} ,
{"Photography"  ,30} ,
{"Psychology"  ,20} ,
}; -- end local skills registry

table.insert(actorNames,"BentleyGarett")
table.insert(actors,BentleyGarett)

--  END Bentley Garett

-- Nicholas Daltry MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
NicholasDaltry={
Name="Nicholas Daltry" , SEX="Female" , AGE="15 " , 

STR=14 , CON=11 , SIZ=9 , INT=15 ,POW=11 , 
DEX=14 , APP=8 , EDU=9 , SAN=55 , HP=10 , 
Magic=11 , Idea=75 , Luck=55 , Know=45 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=891  , Income=1782 ,    Assets= 8910  ,    Securities=891 ,
Property= 7128 ,    
}; --end NicholasDaltry base attributes

-- occupation
NicholasDaltry.Occupation={{"Plainclothes Detective" , "Immune to sanity losses resulting from the sight of normal corpses or injuries. Immune to most Fast Talk and Persuade attempts." }, }
NicholasDaltry.skills ={
{"Credit Rating"  ,40} ,
{"Shotgun"  ,35} ,
{"Pick Pocket"  ,12} ,
{"Locksmith"  ,10} ,
{"Kick"  ,30} ,
{"Photography"  ,15} ,
{"Jump"  ,30} ,
{"Hide"  ,25} ,
{"Fist/Punch"  ,55} ,
{"Sneak"  ,21} ,
{"First Aid"  ,40} ,
{"Disguise"  ,30} ,
{"Bargain"  ,25} ,
{"Law"  ,15} ,
{"Drive Auto"  ,20} ,
{"Fast Talk"  ,50} ,
{"Handgun"  ,40} ,
{"Listen"  ,50} ,
{"Persuade"  ,25} ,
{"Psychology"  ,30} ,
{"Spot Hidden"  ,60} ,
{"Track"  ,10} ,
{"Rifle"  ,30} ,
}; -- end local skills registry
NicholasDaltry.contacts={
"Coroner's Office" ,
"Law Enforcement" ,
"Street Scene" ,
"Organized Crime" ,
};-- end contacts

table.insert(actorNames,"NicholasDaltry")
table.insert(actors,NicholasDaltry)

--  END Nicholas Daltry

-- Paul Evans MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
PaulEvans={
Name="Paul Evans" , SEX="Male" , AGE="28 " , 

STR=3 , CON=8 , SIZ=9 , INT=12 ,POW=10 , 
DEX=13 , APP=13 , EDU=19 , SAN=50 , HP=9 , 
Magic=10 , Idea=60 , Luck=50 , Know=95 ,
Move=8  , Armor=0 , DamageBonus="-1D6" ,
-- money
Cash=773  , Income=1545 ,    Assets= 7726  ,    Securities=773 ,
Property= 6180 ,    
}; --end PaulEvans base attributes

-- occupation
PaulEvans.Occupation={{"Private Eye" , "Lowered or negated sanity losses when viewing murder victims, gross injuries, etc." }, }
PaulEvans.skills ={
{"Accounting"  ,30} ,
{"Handgun"  ,30} ,
{"Kick"  ,27} ,
{"Listen"  ,40} ,
{"Locksmith"  ,20} ,
{"Photography"  ,40} ,
{"Pick Pocket"  ,30} ,
{"Bargain"  ,30} ,
{"Climb"  ,60} ,
{"Disguise"  ,40} ,
{"Drive Auto"  ,40} ,
{"Fast Talk"  ,50} ,
{"Fist/Punch"  ,50} ,
{"Grapple"  ,25} ,
{"Head Butt"  ,30} ,
{"Hide"  ,40} ,
{"Jump"  ,40} ,
{"Law"  ,20} ,
{"Library Use"  ,40} ,
{"Persuade"  ,20} ,
{"Sneak"  ,20} ,
{"Swim"  ,25} ,
{"Track"  ,11} ,
{"Spot Hidden"  ,50} ,
}; -- end local skills registry
PaulEvans.contacts={
"Law Enforcement" ,
"Newspaper Morgues" ,
"Criminals" ,
"Office Workers" ,
};-- end contacts

table.insert(actorNames,"PaulEvans")
table.insert(actors,PaulEvans)

--  END Paul Evans

-- Adam Graves MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
AdamGraves={
Name="Adam Graves" , SEX="Male" , AGE="30 " , 

STR=12 , CON=13 , SIZ=8 , INT=8 ,POW=11 , 
DEX=8 , APP=5 , EDU=18 , SAN=55 , HP=11 , 
Magic=11 , Idea=40 , Luck=55 , Know=90 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=3750  , Income=7500 ,    Assets= 37500  ,    Securities=3750 ,
Property= 30000 ,    
}; --end AdamGraves base attributes

-- occupation
AdamGraves.Occupation={{"Private Investigator" , ""}, }
AdamGraves.skills ={
{"Bargain"  ,60} ,
{"Fast Talk"  ,60} ,
{"Law"  ,11} ,
{"Spot Hidden"  ,60} ,
{"Listen"  ,60} ,
{"Credit Rating"  ,25} ,
{"Library Use"  ,50} ,
{"Locksmith"  ,70} ,
{"Persuade"  ,60} ,
{"Photography"  ,50} ,
{"Psychology"  ,70} ,
}; -- end local skills registry
AdamGraves.equipment ={
{"Desk Phone (bridging type)", "","15.75"},
{"Newspaper", "","0.05"},
{"Telegraph Outfit", "","4.25"},
{".38 Short Round (box of 100)", "","2.07"},
{"House (rent per year)", "","1,000"},
{"Felt Fedora", "","8.95"},
{"Oxford Dress Shoes", "","6.95"},
{"Corduroy Norfolk Suit", "","9.95"},
{"Worsted Wool Dress Suit", "","29.5"},
{"Fingerprint Kit", "","5"},
{"Locksmith's Tools, Precision", "","45"},
{"Remington Typewriter", "","40"},
{"Self-filling Fountain Pen", "","1.25"},
{"Umbrella", "","1.79"},
{"Wire Recorder", "","129.95"},
{"Writing Tablet", "","0.2"},
{"Auto First-Aid Kit", "","2.57"},
{"Hudson Model L", "","1,850"},
{"Crowbar", "","2.25"},
{"Tool Outfit (20 tools)", "","12.9"},
{"Box Camera", "","2.29"},
{"Developer Kit", "","4.95"},
{"Folding Pocket Camera", "","16.15"},
{"Movie Film (100-foot roll)", "","5.4"},
{"Movie Camera", "","89"},
{"Movie Projector", "","54"},
{"Photo Printing (per picture)", "","0.05"},
{"Photography Case", "","1.8"},
{"Total Equipment Cost"," 3,357.02"}
}; --end equipement
AdamGraves.contacts={
"Accountants" ,
"Bail Bondsmen" ,
"Bounty Hunters" ,
"Coroner's Office" ,
"District Attorneys" ,
"Fences" ,
"Hobos" ,
"Law Enforcement" ,
"Legal Connections" ,
"Local Law Officials" ,
"Medical Professionals" ,
"Punks" ,
"Safe House" ,
"Street Scene" ,
"Wealthy / Influential Club Members" ,
};-- end contacts

table.insert(actorNames,"AdamGraves")
table.insert(actors,AdamGraves)

--  END Adam Graves

-- Patrick Inverness MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
PatrickInverness={
Name="Patrick Inverness" , SEX="Male" , AGE="30 " , 
Height=6   , Weight= 160, 
CodeName= "StinkFace"   ,

STR=11 , CON=10 , SIZ=10 , INT=18 ,POW=5 , 
DEX=8 , APP=9 , EDU=16 , SAN=17 , HP=10 , 
Magic=5 , Idea=90 , Luck=25 , Know=80 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=3750  , Income=7500 ,    Assets= 37500  ,    Securities=3750 ,
Property= 30000 ,    
Nationality= "IrishGerman" ,  Birthplace= "Hoboken" ,    
Residence=[[Boston]],
MentalDisorders=[[mummyphobia]],
EpisodesofInsanity=[[1]],
College=[[ Mcowen College,NJ
Phd Psychology]],
Description=[[Skinny and tall, non descript school principal looking guy.]],
Wounds=[[none]],
Marks=[[none]],
Family=[[Brother
Uncle
Cousins
Grandma
]], 
}; --end PatrickInverness base attributes

-- occupation
PatrickInverness.Occupation={{"Private Investigator" , ""}, }
PatrickInverness.skills ={
{"Bargain"  ,60} ,
{"Fast Talk"  ,60} ,
{"Occult"  ,12} ,
{"Cthulhu Mythos"  ,18} ,
{"English"  ,80} ,
{"Law"  ,11} ,
{"Spot Hidden"  ,60} ,
{"Listen"  ,60} ,
{"Credit Rating"  ,25} ,
{"Library Use"  ,50} ,
{"Locksmith"  ,70} ,
{"Persuade"  ,60} ,
{"Photography"  ,50} ,
{"Psychology"  ,70} ,
}; -- end local skills registry
PatrickInverness.equipment ={
{"Desk Phone (bridging type)", "","15.75"},
{"Newspaper", "","0.05"},
{"Telegraph Outfit", "","4.25"},
{".38 Short Round (box of 100)", "","2.07"},
{"House (rent per year)", "","1,000"},
{"Felt Fedora", "","8.95"},
{"Oxford Dress Shoes", "","6.95"},
{"Corduroy Norfolk Suit", "","9.95"},
{"Worsted Wool Dress Suit", "","29.5"},
{"Fingerprint Kit", "","5"},
{"Locksmith's Tools, Precision", "","45"},
{"Remington Typewriter", "","40"},
{"Self-filling Fountain Pen", "","1.25"},
{"Umbrella", "","1.79"},
{"Wire Recorder", "","129.95"},
{"Writing Tablet", "","0.2"},
{"Auto First-Aid Kit", "","2.57"},
{"Hudson Model L", "","1,850"},
{"Crowbar", "","2.25"},
{"Tool Outfit (20 tools)", "","12.9"},
{"Box Camera", "","2.29"},
{"Developer Kit", "","4.95"},
{"Folding Pocket Camera", "","16.15"},
{"Movie Film (100-foot roll)", "","5.4"},
{"Movie Camera", "","89"},
{"Movie Projector", "","54"},
{"Photo Printing (per picture)", "","0.05"},
{"Photography Case", "","1.8"},
{"Total Equipment Cost"," 3,357.02"}
}; --end equipement
PatrickInverness.contacts={
"Accountants" ,
"Bail Bondsmen" ,
"Bounty Hunters" ,
"Coroner's Office" ,
"District Attorneys" ,
"Fences" ,
"Hobos" ,
"Law Enforcement" ,
"Legal Connections" ,
"Local Law Officials" ,
"Medical Professionals" ,
"Punks" ,
"Safe House" ,
"Street Scene" ,
"Wealthy / Influential Club Members" ,
};-- end contacts
PatrickInverness.history=[[A man with a past shrouded in mystery. ]]; -- end history
PatrickInverness.tomesread={
{"Book of Dzyan" ,   "SAN 5"},
{"Language: English"},
 {"Weeks: 14"},
 {"Sanity Loss: 1D3/1D6"},
 {"Cthulhu Mythos: +14"},
 {"Skill Increase: Occult: check"},
 {"Spells: Call Forth Childe of the Woode (Summon/Bind Dark Young); Call Forth Wind Spirit (Summon/Bind Byakhee); Call Forth the Unseen Walker (Summon/Bind Dimensional Shambler); Dream Vision (Contact Cthulhu)"},
 {"Sanity Lost: 5"},
{"Johansen Narrative" ,   "SAN 2"},
{"Language: English"},
 {"Author: Gustaf Johansen"},
 {"Weeks: 6"},
 {"Sanity Loss: 1D3/1D6"},
 {"Cthulhu Mythos: +4"},
 {"Sanity Lost: 2"},
};--end tomes
PatrickInverness.encounters={
{"Carter, Randolph","0 SAN","SAN-"},
{"Bootlegger","0 SAN","SAN-"},
{"Mummy","1 SAN","SAN-1/1D8"},
{"Gun Moll","0 SAN","SAN-"},
{"Dog","0 SAN","SAN-"},
};-- end encoutners
PatrickInverness.details=[[
This is the horrible truth that nobody should know
]];--end details

table.insert(actorNames,"PatrickInverness")
table.insert(actors,PatrickInverness)

--  END Patrick Inverness

-- Albert Landon MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
AlbertLandon={
Name="Albert Landon" , SEX="Male" , AGE="47 " , 

STR=7 , CON=17 , SIZ=14 , INT=14 ,POW=12 , 
DEX=12 , APP=8 , EDU=14 , SAN=60 , HP=16 , 
Magic=12 , Idea=70 , Luck=60 , Know=70 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=5000  , Income=10000 ,    Assets= 50000  ,    Securities=5000 ,
Property= 40000 ,    
}; --end AlbertLandon base attributes

-- occupation
AlbertLandon.Occupation={{"Professor" , ""}, }
AlbertLandon.skills ={
{"Biology"  ,60} ,
{"Chemistry"  ,60} ,
{"Credit Rating"  ,20} ,
{"Greek"  ,60} ,
{"Library Use"  ,50} ,
{"Persuade"  ,12} ,
{"Psychology"  ,6} ,
{"Bargain"  ,20} ,
{"Astronomy"  ,4} ,
{"Natural History"  ,15} ,
{"Occult"  ,10} ,
{"French"  ,15} ,
{"Italian"  ,30} ,
{"Basque"  ,10} ,
{"Latin"  ,40} ,
{"Spanish"  ,30} ,
{"Architectural History"  ,8} ,
}; -- end local skills registry

table.insert(actorNames,"AlbertLandon")
table.insert(actors,AlbertLandon)

--  END Albert Landon

-- Rebecca Stansfield MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
RebeccaStansfield={
Name="Rebecca Stansfield" , SEX="Female" , AGE="22 " , 

STR=5 , CON=9 , SIZ=13 , INT=15 ,POW=16 , 
DEX=8 , APP=12 , EDU=16 , SAN=80 , HP=11 , 
Magic=16 , Idea=75 , Luck=80 , Know=80 ,
Move=8  , Armor=0 , DamageBonus="none" ,
-- money
Cash=1779  , Income=3558 ,    Assets= 17790  ,    Securities=1779 ,
Property= 14232 ,    
}; --end RebeccaStansfield base attributes

-- occupation
RebeccaStansfield.Occupation={{"Reporter" , "Depending upon the beat the reporter covers, he may have grown calloused to the sight of human violence and suffering and may suffer reduced or negated sanity losses for witnessing such things." }, }
RebeccaStansfield.skills ={
{"Bargain"  ,26} ,
{"Climb"  ,40} ,
{"Conceal"  ,25} ,
{"Disguise"  ,50} ,
{"English"  ,80} ,
{"Fast Talk"  ,50} ,
{"Hide"  ,50} ,
{"Jump"  ,40} ,
{"Listen"  ,50} ,
{"Persuade"  ,40} ,
{"Psychology"  ,40} ,
{"Sneak"  ,40} ,
{"Spot Hidden"  ,50} ,
{"History"  ,23} ,
{"Natural History"  ,11} ,
{"Shorthand"  ,20} ,
{"Law"  ,10} ,
{"Geology"  ,10} ,
{"Chemistry"  ,20} ,
{"Biology"  ,20} ,
{"Art History"  ,20} ,
{"Architectural History"  ,15} ,
{"Archaeology"  ,15} ,
{"Anthropology"  ,15} ,
{"Typing"  ,15} ,
}; -- end local skills registry
RebeccaStansfield.contacts={
"News Industry" ,
"High Society" ,
"Local Government" ,
"Politicians" ,
"Finance World" ,
"Sports Professionals" ,
"Police" ,
"Organized Crime" ,
"Street Scene" ,
};-- end contacts

table.insert(actorNames,"RebeccaStansfield")
table.insert(actors,RebeccaStansfield)

--  END Rebecca Stansfield

-- Butch Ruffems MetaCreator .flt to .lua  
-- insert dofile("cocview.lua")  here for functionality
ButchRuffems={
Name="Butch Ruffems" , SEX="Male" , AGE="20 " , 

STR=13 , CON=9 , SIZ=15 , INT=10 ,POW=7 , 
DEX=10 , APP=12 , EDU=14 , SAN=35 , HP=12 , 
Magic=7 , Idea=50 , Luck=35 , Know=70 ,
Move=8  , Armor=0 , DamageBonus="+1D4" ,
-- money
Cash=49  , Income=97 ,    Assets= 486  ,    Securities=49 ,
Property= 388 ,    
}; --end ButchRuffems base attributes

-- occupation
ButchRuffems.Occupation={{"Punk" , ""}, }
ButchRuffems.skills ={
{"Club"  ,56} ,
{"Handgun"  ,30} ,
{"Hide"  ,60} ,
{"Sneak"  ,50} ,
{"Fist/Punch"  ,60} ,
{"Grapple"  ,90} ,
{"Head Butt"  ,10} ,
{"Kick"  ,40} ,
{"Knife"  ,70} ,
{"Pick Pocket"  ,90} ,
{"Throw"  ,50} ,
}; -- end local skills registry
ButchRuffems.contacts={
"Street  Criminals" ,
"Gangsters" ,
"Punks" ,
"Fences" ,
"Police" ,
};-- end contacts

table.insert(actorNames,"ButchRuffems")
table.insert(actors,ButchRuffems)

--  END Butch Ruffems
dofile(gameroot.."Cthulhuskills.lua")
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
dofile(gameroot.."Cthulhu1920OCC.lua")
function hasSkillDescription(b)
OccupationsList:make_current();

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
occSkills={}

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
listactors()
editorPrint(cocView(actors[2]))
OccupationsBrowser:clear()
c=CthulhuOccupations
for i,v in pairs(c) do OccupationsBrowser:add(v[1]) end

end
do CallOfCthulhuCDetails= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Details")
CallOfCthulhuCDetails:label(gLabelTable[#gLabelTable])
CallOfCthulhuCDetails:resize(161,132,597,428)
--unknown attribute: hide
Fl_Group:current():resizable(CallOfCthulhuCDetails)
CallOfCthulhuCDetails:size_range(470,474,2048,2048)
do output1= fltk:Fl_Output(0,0,0,0,"")
output1:resize(160,60,545,20)
output1:box(fltk.FL_NO_BOX)
output1:labelsize(12)
output1:textfont(2)
output1:textsize(12)
end

do editor= fltk:Fl_Text_Editor(0,0,0,0,"")
editor:callback(editorChangedContents)
editor:resize(160,83,435,334)
editor:align(161)
editor:when(1)
editor:textfont(4)
editor:textsize(12)
end

do NameInput= fltk:Fl_Input(0,0,0,0,"")
NameInput:resize(5,30,145,25)
NameInput:labelsize(11)
NameInput:textsize(12)
end

do Occupation= fltk:Fl_Output(0,0,0,0,"")
Occupation:resize(5,5,265,25)
Occupation:box(fltk.FL_NO_BOX)
Occupation:labelsize(12)
Occupation:textfont(3)
end

do mastertab= fltk:Fl_Tabs(0,0,0,0,"")
mastertab:resize(5,60,145,357)
Fl_Group:current():resizable(mastertab)
do DetailsGroup= fltk:Fl_Group(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Details")
DetailsGroup:label(gLabelTable[#gLabelTable])
DetailsGroup:resize(6,83,142,331)
--unknown attribute: hide
do DetailsBrowser= fltk:Fl_Browser(0,0,0,0,"")
DetailsBrowser:callback(viewdetails)
DetailsBrowser:resize(9,83,90,330)
DetailsBrowser:type(1)
DetailsBrowser:box(fltk.FL_DOWN_BOX)
DetailsBrowser:labelsize(11)
DetailsBrowser:align(5)
DetailsBrowser:textsize(11)
end

do ValuesBrowser= fltk:Fl_Browser(0,0,0,0,"")
ValuesBrowser:callback(viewdetails)
ValuesBrowser:resize(100,84,48,330)
ValuesBrowser:type(1)
ValuesBrowser:box(fltk.FL_DOWN_BOX)
ValuesBrowser:labelsize(11)
ValuesBrowser:align(5)
ValuesBrowser:textsize(11)
end
Fl_Group:current(Fl_Group:current():parent())
end

do SkillsGroup= fltk:Fl_Group(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Skills")
SkillsGroup:label(gLabelTable[#gLabelTable])
SkillsGroup:resize(6,84,144,330)
do SkillsBrowser= fltk:Fl_Browser(0,0,0,0,"")
SkillsBrowser:callback(viewskills)
SkillsBrowser:resize(9,84,90,330)
SkillsBrowser:type(1)
SkillsBrowser:labelsize(11)
SkillsBrowser:align(5)
SkillsBrowser:textsize(11)
end

do SkillsValuesBrowser= fltk:Fl_Browser(0,0,0,0,"")
SkillsValuesBrowser:callback(viewdetails)
SkillsValuesBrowser:resize(100,84,48,330)
SkillsValuesBrowser:type(1)
SkillsValuesBrowser:labelsize(11)
SkillsValuesBrowser:align(5)
SkillsValuesBrowser:textsize(11)
end
Fl_Group:current(Fl_Group:current():parent())
end
end
end
CallOfCthulhuCDetails:show()

do CharactersList= fltk:Fl_Double_Window(0,0,0,0,"")
CharactersList:resize(6,148,152,402)
--unknown attribute: hide
Fl_Group:current():resizable(CharactersList)
do CharacterBrowser= fltk:Fl_Browser(0,0,0,0,"")
CharacterBrowser:callback(viewcharacter)
CharacterBrowser:resize(5,32,140,361)
CharacterBrowser:type(1)
CharacterBrowser:labelsize(11)
CharacterBrowser:align(5)
CharacterBrowser:textsize(12)
Fl_Group:current():resizable(CharacterBrowser)
end

do opener= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Open...")
opener:label(gLabelTable[#gLabelTable])
opener:callback(openScriptC)
opener:resize(55,3,45,22)
opener:labelsize(11)
end

do saver= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Save")
saver:label(gLabelTable[#gLabelTable])
saver:callback(saveScriptC)
saver:resize(105,3,45,22)
saver:labelsize(11)
--unknown attribute: deactivate
end

do closer= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Close")
closer:label(gLabelTable[#gLabelTable])
closer:callback(closeScriptC)
closer:resize(5,3,45,22)
closer:labelsize(11)
--unknown attribute: deactivate
end
end
CharactersList:show()

do OccupationsList= fltk:Fl_Double_Window(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "OCC")
OccupationsList:label(gLabelTable[#gLabelTable])
OccupationsList:resize(159,135,817,358)
--unknown attribute: hide
Fl_Group:current():resizable(OccupationsList)
do editorB= fltk:Fl_Text_Editor(0,0,0,0,"")
editorB:resize(365,36,440,312)
editorB:align(161)
editorB:when(1)
editorB:textfont(4)
editorB:textsize(12)
Fl_Group:current():resizable(editorB)
end

do OccupationsBrowser= fltk:Fl_Browser(0,0,0,0,"")
OccupationsBrowser:callback(viewoccupation)
OccupationsBrowser:resize(5,32,195,314)
OccupationsBrowser:type(2)
OccupationsBrowser:labelsize(11)
OccupationsBrowser:align(5)
OccupationsBrowser:textsize(11)
end

do openerocc= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Open...")
openerocc:label(gLabelTable[#gLabelTable])
openerocc:resize(55,3,45,22)
openerocc:labelsize(11)
end

do saverocc= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Save")
saverocc:label(gLabelTable[#gLabelTable])
saverocc:resize(105,3,45,22)
saverocc:labelsize(11)
--unknown attribute: deactivate
end

do closerocc= fltk:Fl_Button(0,0,0,0,"")
if gLabelTable==nil then gLabelTable={} end
table.insert(gLabelTable, "Close")
closerocc:label(gLabelTable[#gLabelTable])
closerocc:resize(5,3,45,22)
closerocc:labelsize(11)
--unknown attribute: deactivate
end

do OccSkillsBrowser= fltk:Fl_Browser(0,0,0,0,"")
OccSkillsBrowser:callback(viewskillsB)
OccSkillsBrowser:resize(205,34,150,314)
OccSkillsBrowser:type(2)
OccSkillsBrowser:labelsize(11)
OccSkillsBrowser:align(5)
OccSkillsBrowser:textsize(11)
end
end
OccupationsList:show()

CallOfCthulhuCDetails:show();
editor_buf = fltk:Fl_Text_Buffer();
editor:buffer( editor_buf );

editor_bufB = fltk:Fl_Text_Buffer();
editorB:buffer( editor_bufB );

CharactersList:show()
closer:deactivate();
saver:deactivate();
CallOfCthulhuCDetails:make_current();
init_viewer()
--end
Fl:run()
