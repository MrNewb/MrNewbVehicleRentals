--		___  ___       _   _                  _      _____              _         _
--		|  \/  |      | \ | |                | |    /  ___|            (_)       | |
--		| .  . | _ __ |  \| |  ___ __      __| |__  \ `--.   ___  _ __  _  _ __  | |_  ___
--		| |\/| || '__|| . ` | / _ \\ \ /\ / /| '_ \  `--. \ / __|| '__|| || '_ \ | __|/ __|
--		| |  | || |   | |\  ||  __/ \ V  V / | |_) |/\__/ /| (__ | |   | || |_) || |_ \__ \
--		\_|  |_/|_|   \_| \_/ \___|  \_/\_/  |_.__/ \____/  \___||_|   |_|| .__/  \__||___/
--									          							  | |
--									          							  |_|
--
--		  Need support? Join our Discord server for help: https://discord.gg/mrnewbscripts
--		  If you need help with configuration or have any questions, please do not hesitate to ask.
--		  Docs Are Always Available At -- https://mrnewbs-scrips.gitbook.io/guide
--        For paid scripts get them here :) https://mrnewbscripts.tebex.io/


Config = Config or {}

Config.Managment = {
    ["Jims Discount Rentals"] = {
        coords = vector4(-905.4015, -2337.1626, 5.7090, 337.3553),
        entityType = "ped",
        model = "u_m_y_babyd", -- this guy smells
        animdata = {
            dict = "amb@world_human_muscle_flex@arms_in_front@idle_a",
            anim = "idle_b",
            flags = 1,
        },
        blip = {sprite = 227,color = 5,scale = 0.8,},
        stock = {
            ["brioso3"] = {
                model = "brioso3",
                label = "Brioso 300 Widebody",
                price = 550,
            },
            ["issi3"] = {
                model = "issi3",
                label = "Issi Classic",
                price = 1000,
            },
        },
        vehicleSpawn = {
            vector4(-907.0331, -2332.6575, 6.2856, 241.9870),
            vector4(-910.1057, -2322.9688, 6.0314, 240.3886),
            vector4(-908.5958, -2319.6130, 6.0310, 238.7896),
            vector4(-901.8630, -2323.6636, 6.0304, 239.2084),
            vector4(-892.4521, -2329.2664, 6.0347, 239.2064),
            vector4(-894.1158, -2332.3274, 6.0316, 243.7992),
            vector4(-903.4811, -2330.6182, 6.0310, 241.0751),
            vector4(-896.1276, -2335.1057, 6.0322, 244.2357),
            vector4(-906.0961, -2332.7542, 6.0325, 246.1780),
            vector4(-897.0125, -2338.0955, 6.0334, 245.0764),
        }
    },
    ["Mayos Floaters"] = {
        coords = vector4(-760.1650, -1377.5739, 0.5952, 228.3274),
        entityType = "object",
        model = "prop_parkingpay",
        blip = {sprite = 410,color = 10,scale = 0.8,},
        stock = {
            ["dinghy"] = {
                model = "dinghy",
                label = "Dinghy Boat",
                price = 900,
            },
            ["seashark2"] = {
                model = "seashark2",
                label = "Seashark Jetski",
                price = 750,
            },
        },
        vehicleSpawn = {
            vector4(-760.8508, -1373.2836, 0.0976, 231.2200),
            vector4(-758.4174, -1370.3179, 0.0605, 230.0020),
            vector4(-764.7704, -1378.9868, 0.0953, 229.4500),
            vector4(-767.8865, -1381.3644, 0.0729, 232.0041),
        }
    },
    ["Rumaiers Shit Boxes"] = {
        coords = vector4(1409.21, 3618.36, 33.9, 280.85),
        entityType = "ped",
        model = "S_M_Y_Doorman_01",
        blip = {sprite = 410,color = 10,scale = 0.8,},
        stock = {
            ["ratloader"] = {
                model = "ratloader",
                label = "Ratloader",
                price = 500,
            },
            ["voodoo2"] = {
                model = "voodoo2",
                label = "Crap Box",
                price = 500,
            },
        },
        vehicleSpawn = {
            vector4(1413.3, 3621.35, 34.89, 197.54),
            vector4(1416.47, 3622.27, 34.87, 197.9),
            vector4(1420.44, 3623.05, 34.87, 193.55),
            vector4(1424.34, 3624.07, 34.87, 195.6),
        }
    },
}