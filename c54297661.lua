--ディメンション・リフレクター
function c54297661.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c54297661.cost)
	e1:SetTarget(c54297661.target)
	e1:SetOperation(c54297661.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54297661,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c54297661.damcon)
	e2:SetTarget(c54297661.damtg)
	e2:SetOperation(c54297661.damop)
	c:RegisterEffect(e2)
end
function c54297661.mzfilter(c,tp)
	return c:GetSequence()<5
end
function c54297661.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if chk==0 then return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c54297661.mzfilter,ct,nil,tp)) end
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:FilterSelect(tp,c54297661.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=rg:FilterSelect(tp,c54297661.mzfilter,2,2,nil,tp)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c54297661.filter(c,tp)
	return c:IsFaceup()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,54297661,0,TYPES_EFFECT_TRAP_MONSTER,c:GetAttack(),c:GetDefense(),4,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK)
end
function c54297661.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c54297661.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingTarget(c54297661.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c54297661.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c54297661.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,54297661,0,TYPES_EFFECT_TRAP_MONSTER,atk,def,4,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c54297661.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c54297661.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c54297661.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetAttack(),REASON_EFFECT)
end
