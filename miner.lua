local component = require("component")
local event = require("event")
local term = require("term")
local sides = require("sides")

local gpu = component.gpu
local computer = component.computer
local modem = component.modem
local rack = component.oc_rack

-- Configuration
local diamondValue = 100 -- Valeur de chaque diamant
local energyConsumption = 5 -- Consommation d'énergie par bloc miné

local function displayWelcomeScreen()
  term.clear()
  gpu.setResolution(80, 25)
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
  gpu.fill(1, 1, 80, 25, " ")

  -- Affichage stylé
  gpu.set(28, 5, "******************************")
  gpu.set(28, 6, "*        Bitcoin Miner       *")
  gpu.set(28, 7, "******************************")

  gpu.set(28, 9, "Veuillez entrer le nom de la personne à qui les diamants reviendront :")
  gpu.set(28, 11, "Nom : ")
end

local function mineDiamonds(minerName)
  term.clear()
  gpu.setResolution(80, 25)
  gpu.setForeground(0xFFFFFF)
  gpu.setBackground(0x000000)
  gpu.fill(1, 1, 80, 25, " ")

  -- Affichage stylé
  gpu.set(28, 5, "******************************")
  gpu.set(28, 6, "*        Bitcoin Miner       *")
  gpu.set(28, 7, "******************************")

  gpu.set(28, 9, "Nom de la personne : " .. minerName)
  gpu.set(28, 11, "Minage en cours...")

  while true do
    os.sleep(0.1)
    
    -- Vérifier si l'énergie est suffisante pour continuer à miner
    if rack.getEnergyStored() < energyConsumption then
      gpu.set(28, 13, "Pas assez d'énergie pour continuer.")
      gpu.set(28, 14, "Arrêt du minage.")
      break
    end
    
    -- Minage d'un bloc de diamant
    rack.setOutput(sides.bottom, 15) -- Activer l'activation du bas pour miner
    os.sleep(0.5) -- Temps pour le minage
    rack.setOutput(sides.bottom, 0) -- Désactiver l'activation du bas
    gpu.set(28, 13, "Bloc de diamant miné !")

    -- Envoyer le diamant à la personne sélectionnée
    modem.send("player_inventory", diamondValue, minerName)
  end

  gpu.set(28, 16, "Minage terminé.")
end

local function main()
  displayWelcomeScreen()

  -- Attendre la saisie du nom de la personne
  local _, _, _, _, _, minerName = event.pull("key_up")
  mineDiamonds(minerName)
end

main()
