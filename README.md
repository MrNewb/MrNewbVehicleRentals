# MrNewbVehicleRentals

Rental desks (peds or props), a `rental_paperwork` item, and nearby returns. Cars, bikes, boats — whatever you put in stock.

[Documentation](https://mrnewb.github.io/docs/mrnewbvehiclerentals) · [GitHub](https://github.com/MrNewb/MrNewbVehicleRentals) · [Discord](https://discord.gg/mrnewbscripts) · [Preview](https://www.youtube.com/watch?v=uJylvMP8_PY)

## Install

Needs [ox_lib](https://github.com/overextended/ox_lib) and [Newb_Bridge](https://github.com/MrNewb/Newb_Bridge). Framework, inventory, fuel, and vehicle keys come through the bridge.

```cfg
ensure ox_lib
ensure Newb_Bridge
ensure MrNewbVehicleRentals
```

Add the `rental_paperwork` item and copy `[INSTALL]/images/rental_paperwork.png` into your inventory images folder. Full steps: [docs](https://mrnewb.github.io/docs/mrnewbvehiclerentals/install).

## Config

`configs/config.lua` — `Config.Agencies`.

Each location key is the desk id (menu title, blip name, paperwork `rentalLocation`). Fields: `coords`, `model`, `stock`, `vehicleSpawn`, `platePrefix`, optional `blip` / `animdata`. `blip.category` (or `Config.BlipCategory`) groups desks under one map legend entry; `Config.BlipCategoryLabel` names custom categories 12–133. `entityType` is optional leftover; ped vs prop comes from `model`.
