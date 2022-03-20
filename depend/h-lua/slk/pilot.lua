---@param _v{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos_1,UnButtonpos_2,Buttonpos_1,Buttonpos_2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID,EfctID,Tip,Ubertip,targs,DataA,DataB,DataC,DataD,DataE,DataF,Cast,Cool,Dur,HeroDur,Cost,Rng,Area,_id_force,_class,_type,_parent,_desc,_attr,_remarks,_lv}
_ability = function(_v)
    return _v
end

---@param _v{abilList,Requires,Requiresamount,Name,Description,Tip,Ubertip,Hotkey,Art,scale,file,Buttonpos_1,Buttonpos_2,selSize,colorR,colorG,colorB,armor,Level,oldLevel,class,goldcost,lumbercost,HP,stockStart,stockRegen,stockMax,prio,cooldownID,ignoreCD,morph,drop,powerup,sellable,pawnable,droppable,pickRandom,uses,perishable,usable,_id_force,_class,_type,_parent,_attr,_remarks,_cooldown,_cooldownTarget}
_item = function(_v)
    return _v
end

---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id_force,_class,_type,_parent,_attr}
_unit = function(_v)
    return _v
end

---@param _v{Effectsound,Effectsoundlooped,EditorSuffix,EditorName,Bufftip,Buffubertip,Buffart,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,EffectArt,Effectattach,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,LightningEffect,Missilearc_1,MissileHoming_1,Spelldetail,isEffect,race,_id_force}
_buff = function(_v)
    return _v
end

---@param _v{Requires,Requiresamount,effect,EditorSuffix,Name,Hotkey,Tip,Ubertip,Buttonpos_1,Buttonpos_2,Art,maxlevel,race,goldbase,lumberbase,timebase,goldmod,lumbermod,timemod,class,inherit,global,_id_force}
_upgrade = function(_v)
    return _v
end

---@alias pilotAttr {disabled,life,mana,move,defend,defend_white,defend_green,attack_speed,attack_space,attack_space_origin,attack,attack_white,attack_green,attack_range,attack_range_acquire,str,agi,int,str_green,agi_green,int_green,str_white,agi_white,int_white,life_back,mana_back,reborn,swim_oppose,broken_oppose,silent_oppose,unarm_oppose,lightning_chain_oppose,crack_fly_oppose,gold_ratio,lumber_ratio,exp_ratio,sell_ratio}
---@param _v pilotAttr
_attr = function(_v)
    return _v
end

---@alias pilotUnitCreate {register,registerOrderEvent,whichPlayer,id,x,y,height,timeScale,modelScale,red,green,blue,opacity,qty,period,during,facing,facingX,facingY,facingUnit,attackX,attackY,attackUnit,isOpenSlot,isShadow,isUnSelectable,isPause,isInvulnerable,isShareSight,attr}
---@alias pilotEnemyCreate {teamNo,register,registerOrderEvent,id,x,y,height,timeScale,modelScale,red,green,blue,opacity,qty,period,during,facing,facingX,facingY,facingUnit,attackX,attackY,attackUnit,isOpenSlot,isShadow,isUnSelectable,isPause,isInvulnerable,isShareSight,attr}
---@alias pilotWeatherCreate {x,y,w,h,whichRect,type,during}
---@alias pilotRectLock {type,during,width,height,lockRect,lockUnit,lockX,lockY}
---@alias pilotQuestCreate {side:"位置",title:"标题",content:"内容",icon:"图标",during:"持续时间"}
---@alias pilotItemCreate {id,charges,whichUnit,x,y,during}
---@alias pilotHeroBuildSelector {heroes,during,type,buildX,buildY,buildDistance,buildRowQty,tavernId,tavernUnitQty,onUnitSell,direct}
---@alias pilotDialogCreate {title,buttons}
---@alias pilotDamage {sourceUnit,targetUnit,damage,damageString,damageRGB,effect,damageSrc}
---@alias pilotDamageStep {sourceUnit,targetUnit,damage,damageString,damageRGB,effect,damageSrc,frequency,times,extraInfluence}
---@alias pilotDamageRange {sourceUnit,targetUnit,damage,damageString,damageRGB,effect,effectSingle,damageSrc,radius,frequency,times,extraInfluence}
---@alias pilotBroken {sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc}
---@alias pilotSwim {sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc}
---@alias pilotSilent {during,sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc}
---@alias pilotUnArm {during,sourceUnit,targetUnit,damage,odds,percent,effect,damageSrc}
---@alias pilotLightningChain {lightningType,prevUnit,sourceUnit,targetUnit,damage,odds,qty,rate,radius,isRepeat,effect,damageSrc,index,repeatGroup}
---@alias pilotCrackFly {distance,height,during,sourceUnit,targetUnit,damage,odds,effect,damageSrc}
---@alias pilotRangeSwim {radius,during,x,y,filter,sourceUnit,targetUnit,damage,odds,effect,damageSrc}
---@alias pilotWhirlwind {radius,frequency,during,filter,sourceUnit,targetUnit,damage,odds,effect,effectEnum,damageSrc,animation}
---@alias pilotLeap {arrowUnit,sourceUnit,targetUnit,x,y,speed,acceleration,height,shake,filter,tokenX,tokenY,tokenArrow,tokenArrowScale,tokenArrowOpacity,tokenArrowHeight,effectMovement,effectEnd,damageMovement,damageMovementRadius,damageMovementRepeat,damageMovementDrag,damageEnd,damageEndRadius,damageSrc,damageEffect,oneHitOnly,onEnding,extraInfluence}
---@alias pilotLeapPaw {qty,deg,arrowUnit,sourceUnit,targetUnit,x,y,speed,acceleration,height,shake,filter,tokenX,tokenY,tokenArrow,tokenArrowScale,tokenArrowOpacity,tokenArrowHeight,effectMovement,effectEnd,damageMovement,damageMovementRadius,damageMovementRepeat,damageMovementDrag,damageEnd,damageEndRadius,damageSrc,damageEffect,oneHitOnly,onEnding,extraInfluence}
---@alias pilotEffectTTG {msg,width,scale,speed,whichUnit,x,y,red,green,blue}
