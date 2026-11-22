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
--		  Docs Are Always Available At -- https://mrnewb.github.io/docs/
--        For paid scripts get them here :) https://mrnewbscripts.tebex.io/

Config = Config or {}

-- Custom named map legend group (12-133). All agency blips use this unless blip.category overrides.
Config.BlipCategory = 12
Config.BlipCategoryLabel = 'Vehicle Rentals'

Config.Agencies = {
    ['Jims Discount Rentals'] = {
        coords = vector4(-905.4276, -2337.7114, 6.7090, 330.5889),
        entityType = 'ped',
        model = 'u_m_y_babyd',
        platePrefix = 'JIM',
        animdata = {
            dict = 'amb@world_human_muscle_flex@arms_in_front@idle_a',
            anim = 'idle_b',
            flags = 1,
        },
        blip = { sprite = 227, color = 5, scale = 0.8, category = 12 },
        stock = {
            ['brioso3'] = {
                model = 'brioso3',
                label = 'Brioso 300 Widebody',
                price = 550,
            },
            ['issi3'] = {
                model = 'issi3',
                label = 'Issi Classic',
                price = 1000,
            },
        },
        vehicleSpawn = {
            vector4(-912.7270, -2329.4360, 6.2954, 58.1394),
            vector4(-906.7300, -2333.1113, 6.2953, 240.7118),
            vector4(-897.9092, -2338.0105, 6.2953, 61.0785),
            vector4(-896.7548, -2335.0432, 6.2953, 240.4633),
            vector4(-894.8483, -2332.3198, 6.2953, 241.1190),
            vector4(-892.6043, -2329.6106, 6.2953, 247.1866),
            vector4(-902.8368, -2327.6821, 6.2953, 60.1082),
            vector4(-900.7911, -2324.9250, 6.2953, 59.5246),
            vector4(-899.3755, -2321.5093, 6.2953, 239.3996),
            vector4(-891.2350, -2326.4175, 6.2953, 239.3004),
            vector4(-889.3331, -2323.6489, 6.2953, 239.3004),
            vector4(-897.6730, -2318.5405, 6.2953, 64.3004),
            vector4(-896.1400, -2315.6006, 6.2953, 61.2924),
            vector4(-887.7205, -2320.4395, 6.2953, 236.4504),
            vector4(-885.5762, -2317.5527, 6.2953, 56.4504),
            vector4(-894.2373, -2312.7903, 6.2953, 62.9358),
            vector4(-902.8786, -2311.2617, 6.2953, 237.9358),
            vector4(-904.4513, -2314.4109, 6.2953, 62.2745),
            vector4(-906.0839, -2317.1113, 6.2953, 59.7005),
            vector4(-907.9454, -2320.1768, 6.2953, 61.1519),
            vector4(-909.3095, -2323.1094, 6.2953, 63.2661),
            vector4(-912.5367, -2329.4146, 6.2954, 58.2661),
            vector4(-914.3797, -2331.8513, 6.2954, 61.0799),
            vector4(-924.1276, -2326.4768, 6.2954, 59.5046),
            vector4(-922.8095, -2323.7168, 6.2954, 62.2686),
            vector4(-921.0591, -2321.1311, 6.2954, 57.2686),
            vector4(-919.6412, -2318.5378, 6.2954, 62.2686),
            vector4(-918.0682, -2314.1064, 6.2954, 62.2686),
        },
    },
    ['Mayos Floaters'] = {
        coords = vector4(-760.1650, -1377.5739, 0.5952, 228.3274),
        entityType = 'object',
        model = 'prop_parkingpay',
        platePrefix = 'MAY',
        blip = { sprite = 410, color = 10, scale = 0.8, category = 12 },
        stock = {
            ['dinghy'] = {
                model = 'dinghy',
                label = 'Dinghy Boat',
                price = 900,
            },
            ['seashark2'] = {
                model = 'seashark2',
                label = 'Seashark Jetski',
                price = 750,
            },
        },
        vehicleSpawn = {
            vector4(-760.8508, -1373.2836, 0.0976, 231.2200),
            vector4(-758.4174, -1370.3179, 0.0605, 230.0020),
            vector4(-764.7704, -1378.9868, 0.0953, 229.4500),
            vector4(-767.8865, -1381.3644, 0.0729, 232.0041),
        },
    },
    ['Dickles Shit Rentals'] = {
        coords = vector4(-832.0688, -2350.9944, 14.5706, 272.9038),
        entityType = 'ped',
        model = 'S_M_Y_Doorman_01',
        platePrefix = 'DKL',
        blip = { sprite = 410, color = 10, scale = 0.8, category = 12 },
        stock = {
            ['ratloader'] = {
                model = 'ratloader',
                label = 'Ratloader',
                price = 500,
            },
            ['voodoo2'] = {
                model = 'voodoo2',
                label = 'Crap Box',
                price = 500,
            },
        },
        vehicleSpawn = {
            vector4(-829.7709, -2355.3289, 14.1570, 152.9038),
            vector4(-827.0711, -2357.4316, 14.1570, 144.6715),
            vector4(-824.0868, -2359.0693, 14.1570, 150.8973),
            vector4(-821.2453, -2360.8984, 14.1570, 148.6560),
            vector4(-818.3613, -2362.9133, 14.1570, 153.1761),
            vector4(-815.4553, -2364.5342, 14.1570, 152.3871),
            vector4(-812.3224, -2366.3916, 14.1570, 149.2620),
            vector4(-809.4901, -2367.8633, 14.1570, 153.5731),
            vector4(-803.4611, -2354.9768, 14.1569, 331.9185),
            vector4(-806.6766, -2353.6758, 14.1569, 329.8526),
            vector4(-809.3603, -2351.4214, 14.1569, 328.3547),
            vector4(-812.7256, -2350.5303, 14.1569, 328.2943),
            vector4(-815.2297, -2348.5979, 14.1569, 146.9037),
            vector4(-818.4082, -2347.3062, 14.1569, 329.3730),
            vector4(-821.4825, -2345.5044, 14.1569, 330.4319),
            vector4(-824.5955, -2343.7607, 14.1569, 328.7957),
            vector4(-824.2126, -2336.0059, 14.1569, 329.6016),
            vector4(-826.8447, -2333.3823, 14.1569, 331.9117),
            vector4(-829.7424, -2331.7109, 14.1569, 329.6765),
            vector4(-832.6774, -2329.6711, 14.1569, 332.1363),
            vector4(-835.4136, -2327.8806, 14.1569, 324.6911),
        },
    },
    ['Lees Wheely Good Bikes'] = {
        coords = vector4(-1220.1190, -1495.0079, 4.3344, 126.9146),
        entityType = 'ped',
        model = 'S_M_Y_Doorman_01',
        platePrefix = 'LEE',
        blip = { sprite = 410, color = 10, scale = 0.8, category = 12 },
        stock = {
            ['bmx'] = {
                model = 'bmx',
                label = 'bmx',
                price = 150,
            },
        },
        vehicleSpawn = {
            vector4(-1221.1202, -1498.5096, 3.7313, 117.5105),
            vector4(-1223.0009, -1500.1243, 3.7473, 112.5105),
            vector4(-1225.1565, -1500.5570, 3.7280, 32.5105),
            vector4(-1226.4042, -1498.8892, 3.7281, 27.5105),
            vector4(-1227.5983, -1496.7709, 3.7350, 27.5105),
            vector4(-1226.0931, -1495.2921, 3.7495, 122.5105),
            vector4(-1224.5529, -1494.5703, 3.7379, 122.5105),
            vector4(-1225.8691, -1492.5780, 3.7375, 122.5105),
            vector4(-1227.6598, -1493.6882, 3.7533, 117.5105),
            vector4(-1230.1060, -1495.8594, 3.7029, 147.5105),
            vector4(-1229.0813, -1499.0824, 3.6796, 147.5105),
            vector4(-1227.6130, -1501.3683, 3.6778, 142.5105),
            vector4(-1225.8240, -1503.4473, 3.6835, 142.5105),
        },
    },
}
