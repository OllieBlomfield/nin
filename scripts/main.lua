function _init() 
    cartdata("nin_v1")
    dset(1, dget(58)==0 and 48 or 0)
    menu_init() 
end
function _update60() update() end
function _draw() draw() end


--TO DO:
--Fix collision (make more efficient and fix jump x collision bug)
--Fix blood spawning issue after respawn (might be fixed not sure)
--Fix respawn points


--EXPORT GAME.HTML -P CRT