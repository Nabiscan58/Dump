Contagion = {}

Contagion.STAGES = {
  [1] = 60 * 60,        -- 1h: toux
  [2] = 2.5 * 60 * 60,  -- 2h30: tangue (ivresse légère)
  [3] = 3.5 * 60 * 60,  -- 3h30: éternue + mal à marcher/courir
  [4] = 4.5 * 60 * 60   -- 4h30: toux + écran "bourré", marche difficile, -HP / 10 min
}

Contagion.HP_LOSS_INTERVAL = 10 * 60
Contagion.HP_LOSS_AMOUNT = 10