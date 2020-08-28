cheevs = {};
cheevs.goatConvosSeen = Array();
cheevs.cheevoFlags = {
    goat=false,
    act1evidence=false,
    allevidence=false
}

cheevs.registerGoatConvo = function(filename)
    if not cheevs.cheevoFlags.goat then
        if not contains(cheevs.goatConvosSeen,filename) then
            cheevs.goatConvosSeen.push(filename);
            --track the stat in steam too
        end
        if #(cheevs.goatConvosSeen) >= 10 then
            cheevs.cheevoFlags.goat = true;
            Steam.userStats.setAchievement("S5_GOAT");
            Steam.userStats.storeStats();
        end
    end
end;
cheevs.checkEvidence = function()
    if not cheevs.cheevoFlags.allevidence then
        local allEvidenceFound = true;
        local act1EvidenceFound = true;
        for e=1, #(game.evidenceData), 1 do
            local ev = game.evidenceData[e];
            if not game.eflags[ev.id] then
                if ev.id == "Uncertainty" then
                    --no problem- continue
                else
                    allEvidenceFound = false;
                    if (ev.id ~= "ConcreteTub") and (ev.id ~= "RealBullet") and (ev.id ~= "LevelUp") then
                        act1EvidenceFound = false;
                    end
                end
            end
        end
        if act1EvidenceFound then
            cheevs.cheevoFlags.act1evidence = true;
            Steam.userStats.setAchievement("S5_EV1");
            Steam.userStats.storeStats();
        end
        if allEvidenceFound then
            cheevs.cheevoFlags.allevidence = true;
            Steam.userStats.setAchievement("S5_EV2");
            Steam.userStats.storeStats();
        end
    end
end;