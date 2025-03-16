AddCSLuaFile('sh_blinchik.lua')
AddCSLuaFile('cl_blinchik.lua')
include('sh_blinchik.lua')
include('cl_blinchik.lua')
function ENT:Initialize()

    self:SetModel('models/metrostroi_3demc/metrostroi_vending_machine/blinchiki/blin4_hehehe.mdl')
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:EntIndex()
    self.Data = {}
    self:GetPhysicsObject():SetMass(1000)
    self:GetPhysicsObject():SetVelocity((self:GetUp() * 2))
    if self:GetPhysicsObject():IsValid() then 
        self:GetPhysicsObject():Wake()
    end
end

function ENT:Use(activator)

    if not activator:IsPlayer() then
        return
    end

    local healthToAdd = 50
    activator:SetHealth(math.min(activator:Health() + healthToAdd, activator:GetMaxHealth()))

    local randomPitch = math.random(10, 300)

    self:EmitSound("mel/mell.wav", 75, randomPitch)

    self:Remove()
end
