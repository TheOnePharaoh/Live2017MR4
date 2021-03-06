--ストイック・チャレンジ
function c37364101.initial_effect(c)
	c:SetUniqueOnField(1,0,37364101)
	aux.AddEquipProcedure(c,nil,c37364101.filter)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c37364101.atkval)
	c:RegisterEffect(e3)
	--damage change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(c37364101.damval)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e5)
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(37364101,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c37364101.tgcon)
	e6:SetTarget(c37364101.tgtg)
	e6:SetOperation(c37364101.tgop)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(c37364101.desop)
	c:RegisterEffect(e7)
end
function c37364101.filter(c)
	return c:GetOverlayCount()>0
end
function c37364101.atkval(e,c)
	return Duel.GetOverlayCount(e:GetHandlerPlayer(),1,0)*600
end
function c37364101.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 and rc==e:GetHandler():GetEquipTarget() and rc:GetBattleTarget()~=nil then
		return dam*2
	else return dam end
end
function c37364101.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c37364101.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c37364101.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function c37364101.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
