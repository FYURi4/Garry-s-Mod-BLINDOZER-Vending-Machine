AddCSLuaFile('sh_blindozer.lua')
AddCSLuaFile('cl_blindozer.lua')
include('sh_blindozer.lua')
include('cl_blindozer.lua')
util.AddNetworkString( "Pay" )
function ENT:Initialize()

    self:SetModel('models/metrostroi_3demc/metrostroi_vending_machine/Blindozer.mdl')
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetHealth(1000)
    self:EntIndex()
    self:GetPhysicsObject():SetMass(1000)
    self:GetPhysicsObject():SetVelocity((self:GetUp() * 2))
    if self:GetPhysicsObject():IsValid() then 
        self:GetPhysicsObject():Wake()
    end
	self:SetNWInt("owner",self:GetCreator():AccountID())
end

function ENT:Use(activator)

    if self:GetNWBool("isBeingUsed", false) and self:GetNWEntity("user") ~= activator then
        activator:ChatPrint("Этот объект уже используется!")
        return
    end

    local entPos = self:GetPos()
    local plyPos = activator:GetPos()
    local entLeft = -self:GetRight()
    local plyToEnt = (entPos - plyPos):GetNormalized()

    local dot = entLeft:Dot(plyToEnt)

    if dot < 0.7 then 
        activator:ChatPrint("Вы должны находиться спереди объекта, чтобы использовать его!")
        return
    end

    local function StripWeapons(activator)
        local weaponsTable = {}
        for k, v in pairs(activator:GetWeapons()) do
            table.insert(weaponsTable, v:GetClass())
        end
        activator:StripWeapons()
        return weaponsTable
    end

    local function ReturnWeapons(activator, weaponsTable)
        for k, v in pairs(weaponsTable) do
            activator:Give(v)
        end
    end

    local function FreezePlayer(ply)
        ply:SetVelocity(Vector(0, 0, 0))
        ply:SetMoveType(MOVETYPE_NONE)
        ply:SetNWBool("Frozen", true)
    end

    local function UnfreezePlayer(ply)
        ply:SetMoveType(MOVETYPE_WALK)
        ply:SetNWBool("Frozen", false)
    end

    if activator:GetEyeTrace().Entity == self then
        activator:SetNWVector("Position", self:LocalToWorld(Vector(18.5, -27.5, 58.2)))
        activator:SetNWAngle("Angles", self:LocalToWorldAngles(Angle(0, 90, 0)))

        if activator:GetNWBool("isUsingEntity") then
            ReturnWeapons(activator, self.savedWeapons)
            UnfreezePlayer(activator)
            activator:SetNWBool("isUsingEntity", false)
            self:SetNWBool("isBeingUsed", false)
            self:SetNWEntity("user", nil)
        else
            self.savedWeapons = StripWeapons(activator)
            FreezePlayer(activator)
            activator:SetNWBool("isUsingEntity", true)
            self:SetNWBool("isBeingUsed", true)
            self:SetNWEntity("user", activator)
        end
    elseif activator:GetEyeTrace().Entity ~= self then
        ReturnWeapons(activator, self.savedWeapons)
        UnfreezePlayer(activator)
        activator:SetNWBool("isUsingEntity", false)
        self:SetNWBool("isBeingUsed", false)
        self:SetNWEntity("user", nil)
    end
end

function ENT:AcceptInput(name,ply,caller)
	net.Receive("Pay",function(len,ply)
		local Pay = net.ReadTable()
		local ent = ents.Create("Blinchik")
		
		ent:SetPos(self:LocalToWorld(Vector(-14, -16, 10)))
		ent:SetAngles(self:GetAngles())
		
		ent:Spawn()
		
		ent.Data = Pay
		
		local phys = ent:GetPhysicsObject()
		phys:SetMass(ent.Data.massa)
		if IsValid(phys) then
			phys:Wake()
		end
	end)
end

--[MADE IN RUSSIAN]--
--[MADE COPY FYURI4]--
--[MADE COPY 3DEMC]--
--[Copyright 2024 BLINDOZER. Все права защищены. ООО "Сити Венд Кафе"]--
