--Prayer to the Evil Spirits
function c511002822.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74335036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002822.target)
	e1:SetOperation(c511002822.activate)
	c:RegisterEffect(e1)
	if not c511002822.global_check then
		c511002822.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c511002822.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511002822.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c511002822.filter1(c,e)
	return c:IsLocation(LOCATION_HAND) and c:IsAngel() and (not e or not c:IsImmuneToEffect(e))
end
function c511002822.filter2(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAngel() and (not e or not c:IsImmuneToEffect(e))
end
function c511002822.filter3(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m,nil,tp)
end
function c511002822.fcheck(tp,sg,fc)
	return not sg or (sg:GetCount()==1 and sg:IsExists(function(c)return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)end,1,nil)) or (sg:GetCount()==2 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE))
end
function c511002822.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetFusionMaterial(tp):Filter(c511002822.filter1,nil)
		local mg2=Duel.GetMatchingGroup(c511002822.filter2,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		Auxiliary.FCheckAdditional=c511002822.fcheck
		Auxiliary.FCheckExact=2
		local res=Duel.IsExistingMatchingCard(c511002822.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):Filter(c511002822.filter2,nil)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c511002822.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf)
			end
		end
		Auxiliary.FCheckAdditional=nil
		Auxiliary.FCheckExact=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511002822.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetFusionMaterial(tp):Filter(c511002822.filter1,nil,e)
	local mg=Duel.GetMatchingGroup(c511002822.filter2,tp,LOCATION_GRAVE,0,nil,e)
	mg1:Merge(mg)
	Auxiliary.FCheckAdditional=c511002822.fcheck
	Auxiliary.FCheckExact=2
	local sg1=Duel.GetMatchingGroup(c511002822.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(c511002822.filter2,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c511002822.filter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,tp)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,tp)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	Auxiliary.FCheckAdditional=nil
	Auxiliary.FCheckExact=nil
end
