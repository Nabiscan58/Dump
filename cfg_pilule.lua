Pilule = {}

-- Libellé de l'item dans la DB ESX
Pilule.ItemName  = 'pilule'
Pilule.ItemLabel = "Pilule de l'oubli"

-- Poids (ESX Legacy) / Limit (anciens ESX). L'auto-détection SQL essaie plusieurs variantes.
Pilule.ItemWeight = 1

-- Effet visuel en secondes
Pilule.EffectDuration = 10

-- Utiliser lib.notify d'ox_lib si dispo
Pilule.UseOxLibNotifyIfAvailable = true