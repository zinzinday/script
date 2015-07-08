--[[
	Wall Position by Manciuszz
	        Huge credit goes to Husky, for his "2D Geometry" library.
	========================================================================
]]

-- Dependencies ----------------------------------------------------------------

require "2DGeometry"

-- Config ----------------------------------------------------------------------

mapRegions = {--                         BOT RIGHT                 BOT LEFT           TOP LEFT               TOP RIGHT

    leftTopLaneWall            = Polygon(Point(37, 1436),  Point(-266, 1450),  Point(104, 11240),  Point(456, 11240)),
    centerTopLaneWall          = Polygon(Point(456, 11240),  Point(104, 11240), Point(506, 12688),  Point(789, 12378)),
    centerTopLaneWallExt1      = Polygon(Point(790, 12382), Point(506, 12688), Point(1531, 13574), Point(1580, 13375)),
    centerTopLaneWallExt2      = Polygon(Point(1580, 13375), Point(1531, 13574), Point(2908, 13948),  Point(2891, 13828)),
    centerTopLaneWallExt3      = Polygon(Point(2891, 13828), Point(2909, 13959), Point(12834, 14393),  Point(12851, 14099)),

    leftBotLaneWall            = Polygon(Point(1125, 167),  Point(1095, 409),  Point(11020, 659),  Point(11073, 386)),
    centerBotLaneWall          = Polygon(Point(11073, 386),  Point(11020, 659), Point(12856, 1840),  Point(13072, 1773)),
    rightBotLaneWall           = Polygon(Point(13072, 1773), Point(12856, 1840), Point(13436, 2982),  Point(13621, 2925)),
    leftTopBotLaneWall         = Polygon(Point(13621, 2925), Point(13436, 2982), Point(13703, 4035),  Point(13996, 4106)),
    centerTopBotLaneWall       = Polygon(Point(13996, 4106), Point(13703, 4035), Point(13816, 13180),  Point(14167, 13181)),

    bottomOuterTurretWall  = Polygon(Point(10286, 1668), Point(9101, 1514),  Point(8874, 2242),  Point(10293, 2040)),
    bottomOuterTurretWall2 = Polygon(Point(8779, 1506),  Point(7742, 1611),  Point(7700, 1900),  Point(8627, 2034)),
    bottomOuterTurretWall3 = Polygon(Point(7529, 1479),  Point(5836, 1561),  Point(5841, 2160),  Point(7588, 1883)),
    bottomOuterTurretWallExt = Polygon(Point(5841, 2160),  Point(6990, 1977),  Point(6676, 2427),  Point(6486, 2394)),

    bottomOuterBlueTurret1    = Polygon(Point(6649, 1155),  Point(6347, 1155),  Point(6347, 1417),  Point(6649, 1417)),
    bottomOuterBlueTurret2    = Polygon(Point(10243, 703),  Point(9941, 703),   Point(9941, 955),  Point(10243, 955)),

    bottomOuterRedTurret1     = Polygon(Point(13622, 4147), Point(13300, 4147), Point(13300, 4459), Point(13622, 4459)),
    bottomOuterRedTurret2     = Polygon(Point(13090, 7851), Point(12760, 7851), Point(12760, 8179), Point(13090, 8179)),

    bottomBlueInhibTurret     = Polygon(Point(3911, 955),   Point(3595, 955),   Point(3595, 1210),  Point(3911, 1210)),
    bottomBlueInhib           = Polygon(Point(3211, 890),   Point(2811, 890),   Point(2811, 1290),  Point(3211, 1290)),

    bottomRedInhibTurret     = Polygon(Point(13364, 10367),   Point(13045, 10367),  Point(13045, 10622),  Point(13364, 10622)),
    bottomRedInhib           = Polygon(Point(13395, 11004),   Point(12995, 11004),  Point(12995, 11404),  Point(13395, 11404)),

    jungleRedNearBlueWall     = Polygon( Point(12602, 7199), Point(12559, 9191), Point(11870, 9223), Point(12038, 7474)),
    jungleRedNearBlueWall1    = Polygon( Point(12633, 5336), Point(12741, 6601), Point(12339, 5648), Point(12260, 5159)),
    jungleRedNearBlueWall2    = Polygon( Point(12553, 6156), Point(12741, 6603), Point(11763, 7138), Point(11617, 6789)),
    jungleRedNearBlueWall3    = Polygon( Point(11800, 4746), Point(11981, 6080), Point(11454, 5875), Point(11800, 4746)),
    jungleRedNearBlueWall3Ext = Polygon( Point(11454, 5874), Point(11979, 6079), Point(11294, 6398), Point(11160, 6115)),
    jungleRedNearBlueWall4    = Polygon( Point(11101, 5420), Point(10875, 5016), Point(11567, 4118), Point(11773, 4306)),
    jungleRedNearBlueWall5    = Polygon( Point(10772, 6334), Point(10088, 6380), Point(9548, 5801), Point(10579, 5399)),
    jungleRedNearBlueWall5Ext1 = Polygon( Point(10772, 6334), Point(10088, 6380), Point(9814, 6869), Point(10208, 6894)),
    jungleRedNearBlueWall5Ext2 = Polygon( Point(10208, 6894), Point(9814, 6869), Point(10078, 7322),  Point(11290, 6958)),
    jungleRedNearBlueWall5Ext3 = Polygon( Point(10078, 7322), Point(11290, 6958), Point(11189, 7203), Point(10814, 7331)),
    jungleRedNearBlueWall6    = Polygon( Point(11360, 7744), Point(11666, 7624), Point(11583, 8558), Point(11225, 8528)),
    jungleRedNearBlueWall6Ext1  = Polygon( Point(11583, 8558), Point(11225, 8530), Point(10956, 8828), Point(11383, 9243)),
    jungleRedNearBlueWall6Ext2  = Polygon( Point(10956, 8827), Point(10148, 9006), Point(10607, 9546), Point(11382, 9243)),
    jungleRedNearBlueWall6Ext3  = Polygon( Point(9992, 8823), Point(9614, 9042), Point(10186, 9673), Point(10607, 9546)),
    jungleRedNearBlueWall7  = Polygon( Point(9424, 6200), Point(8657, 6273), Point(8797, 6805), Point(9558, 6725)),
    jungleRedNearBlueWall7Ext1  = Polygon( Point(8657, 6273), Point(7728, 6961), Point(8133, 7409), Point(8797, 6805)),

    jungleRedNearWolvesWall1  = Polygon( Point(10438, 8087), Point(9884, 8166), Point(10223, 8689), Point(10447, 8469)),
    jungleRedNearWolvesWall1Ext1  = Polygon( Point(9990, 7612), Point(10426, 7581), Point(10438, 8087), Point(9884, 8166)),
    jungleRedNearWolvesWall1Ext2  = Polygon( Point(11008, 7888), Point(10426, 7579), Point(10438, 8087), Point(10924, 8149)),

    jungleRedNearTurretWall1  = Polygon( Point(9454, 8151), Point(8590, 7982), Point(9304, 8700), Point(9651, 8396)),
    jungleRedNearTurretWall1Ext1  = Polygon( Point(9637, 7185), Point(8708, 7312), Point(8590, 7981), Point(9454, 8151)),


    jungleDragonPitWall  = Polygon( Point(10633, 3665), Point(9715, 2942), Point(9873, 4506), Point(10347, 4278)),
    jungleDragonPitWallExt1  = Polygon( Point(9715, 2942), Point(9158, 3363), Point(9169, 3692), Point(9802, 3808)),
    jungleDragonPitWallExt2  = Polygon( Point(9158, 3363), Point(8634, 4029), Point(8946, 4327), Point(9175, 3695)),
    jungleDragonPitWallExt3  = Polygon( Point(8946, 4327), Point(8634, 4029), Point(8600, 4760), Point(9390, 4668)),
    jungleDragonPitWallExt4  = Polygon( Point(9585, 4645), Point(8600, 4760), Point(8381, 5224), Point(9257, 5016)),
    jungleDragonPitWallExt5  = Polygon( Point(8600, 4760), Point(8286, 4894), Point(8276, 5113), Point(8381, 5224)),

    jungleBlueNearWrathsWall = Polygon( Point(7425, 5802), Point(6693, 6320), Point(7083, 6403), Point(8061, 5565)),

    jungleBlueNearRedWall = Polygon( Point(7032, 3694), Point(6618, 3748), Point(6708, 4275), Point(7257, 4085)),
    jungleBlueNearRedWallExt1 = Polygon( Point(7257, 4085), Point(6708, 4275), Point(7221, 4553), Point(8288, 4525)),
    jungleBlueNearRedWallExt2 = Polygon( Point(8106, 3554), Point(7508, 3306), Point(7498, 4188), Point(8288, 4525)),

    jungleBlueDoubleGolemsWall = Polygon( Point(7742, 2205), Point(7320, 2184), Point(7174, 3030), Point(7936, 2646)),
    jungleBlueDoubleGolemsWallExt1 = Polygon( Point(8656, 2408), Point(7936, 2646), Point(7174, 3030), Point(8667, 3210)),
    jungleBlueDoubleGolemsWallExt2 = Polygon( Point(9810, 2408), Point(8656, 2408), Point(8667, 3210), Point(9859, 2688)),

    jungleBlueNearOuterTurret1Wall = Polygon( Point(4899, 3507), Point(4396, 4038), Point(4994, 4611), Point(5307, 3730)),
    jungleBlueNearOuterTurret1WallExt = Polygon( Point(5683, 4517), Point(5307, 3730), Point(4994, 4611), Point(5626, 4834)),

    jungleBlueWrathWall = Polygon( Point(6350, 4576), Point(5934, 4594), Point(5943, 5169), Point(6352, 5337)),
    jungleBlueWrathWallExt1 = Polygon( Point(6350, 4576), Point(5934, 4594), Point(5943, 5169), Point(6352, 5337)),
    jungleBlueWrathWallExt2 = Polygon( Point(5941, 5168), Point(5423, 5022), Point(6268, 6095), Point(6956, 5716)),
    jungleBlueWrathWallExt3 = Polygon( Point(7377, 5040), Point(6825, 5052), Point(6519, 5480), Point(6956, 5716)),

    leftRiverBotWall1      = Polygon(Point(11300, 2450), Point(10859, 1670),  Point(10081, 3000),  Point(10788, 3119)),
    centerRiverBotWall2    = Polygon(Point(12478, 3268), Point(11944, 3082),  Point(11570, 4120),  Point(12617, 5011)),

    jungleBlueBotWall1       = Polygon(Point(5522, 1555), Point(5013, 1544),  Point(5003, 3124),  Point(5510, 2291)),
    jungleBlueBotWall2       = Polygon(Point(5897, 2612), Point(5510, 2291),  Point(5003, 3124),  Point(5493, 3333)),
    jungleBlueNearRedWall1   = Polygon(Point(6727, 2957), Point(6098, 3037),  Point(6328, 3397),  Point(6771, 3363)),
    jungleBlueNearRedWall1Ext1   = Polygon(Point(6328, 3397), Point(6098, 3037),  Point(5751, 3770),  Point(6129, 3804)),
    jungleBlueNearRedWall1Ext2   = Polygon(Point(6129, 3804), Point(5751, 3770),  Point(5858, 4251),  Point(6328, 4264)),

    blueTeamNexus   = Polygon(Point(1404, 1205), Point(846, 1245),  Point(933, 1786), Point(1484, 1715)),
    blueTeamNexusTurret1   = Polygon(Point(1926, 1464), Point(1619, 1464),  Point(1619, 1760), Point(1926, 1760)),
    blueTeamNexusTurret2   = Polygon(Point(1505, 1915), Point(1160, 1915),  Point(1160, 2177), Point(1505, 2177)),

    redTeamNexus   = Polygon(Point(13064, 12764), Point(12499, 12825),  Point(12504, 13415), Point(13093, 13421)),
    redTeamNexusTurret1   = Polygon(Point(12811, 12346), Point(12497, 12346),  Point(12497, 12592), Point(12811, 12592)),
    redTeamNexusTurret2   = Polygon(Point(12294, 12746), Point(11990, 12746),  Point(11990, 13034), Point(12294, 13034)),

--[[TOP side of the map]]
    jungleBlueNearWolvesWall = Polygon(Point(4419, 5655), Point(3714, 4834),  Point(3592, 5550), Point(4098, 5851)),
    jungleBlueNearWolvesWallExt1 = Polygon(Point(3714, 4834), Point(2537, 5218), Point(2840, 6047), Point(3592, 5550)),
    jungleBlueNearWolvesWallExt2 = Polygon(Point(2840, 6047), Point(2661, 5557), Point(2321, 6390), Point(2653, 6450)),
    jungleBlueNearWolvesWallExt3 = Polygon(Point(2653, 6450), Point(2321, 6390), Point(2386, 6896), Point(2730, 6897)),

    jungleNearTopOuterTurret1Wall = Polygon(Point(2187, 5343), Point(1370, 5354), Point(1282, 7406), Point(2062, 7094)),

    jungleBlueWolvesWall = Polygon(Point(3917, 5961), Point(3521, 5966), Point(3677, 6329), Point(4122, 6270)),
    jungleBlueWolvesWallExt1 = Polygon(Point(4122, 6270), Point(3677, 6329), Point(3414, 6588), Point(4078, 6901)),
    jungleBlueWolvesWallExt2 = Polygon(Point(4079, 6901), Point(3063, 6410), Point(3112, 6791), Point(3658, 7006)),

    jungleBlueTeamBlueWall = Polygon(Point(2731, 7198), Point(4060, 7158), Point(3804, 7562),Point(2731, 7598)),
    jungleBlueTeamBlueWallExt1 = Polygon(Point(4184, 7549), Point(4059, 7171), Point(3339, 8295), Point(3848, 8188)),
    jungleBlueTeamBlueWallExt2 = Polygon(Point(3848, 8188), Point(3339, 8295), Point(3356, 9233), Point(4520, 8566)),
    jungleBlueTeamBlueWall2 = Polygon(Point(2947, 8155), Point(2111, 8347), Point(2269, 9856), Point(2511, 8862)),
    jungleBlueTeamBlueWall3 = Polygon(Point(2187, 7455), Point(1263, 7855), Point(1582, 8201), Point(2393, 7763)),
    jungleBlueTeamBlueWall3Ext = Polygon(Point(1583, 8200), Point(1263, 7855), Point(1381, 9191), Point(1901, 9344)),
    jungleBlueTeamBlueWall4 = Polygon(Point(1583, 8200), Point(1263, 7855), Point(1381, 9191), Point(1901, 9344)),
    jungleBlueTeamBlueWall5 = Polygon(Point(1855, 9925), Point(1414, 9562), Point(1400, 11095), Point(2053, 11601)),
    jungleBlueTeamBlueWall5Ext1 = Polygon(Point(2818, 10093), Point(1864, 10088), Point(2052, 11596), Point(2493, 10766)),
    jungleBlueTeamBlueWall5Ext2 = Polygon(Point(3143, 9420), Point(2903, 8988), Point(2594, 10092), Point(2818, 10093)),

    jungleNearBlueOuterTurret1Wall = Polygon(Point(4760, 5821), Point(4370, 5955), Point(4494, 6831), Point(5562, 6722)),
    jungleNearBlueOuterTurret1WallExt = Polygon(Point(5568, 6729), Point(4494, 6830), Point(4419, 7306), Point(5023, 7346)),

    leftTopRiverWallNearMid = Polygon(Point(6269, 7327), Point(6071, 7025), Point(4381, 8072), Point(5043, 8393)),
    rightTopRiverWallNearMid = Polygon(Point(7259, 8000), Point(6992, 7728), Point(5829, 8774), Point(6156, 8933)),

    blueTeamBaseWalls = Polygon(Point(3268, 4083), Point(1246, 4467), Point(1224, 4934), Point(3487, 4513)),
    blueTeamBaseWalls2 = Polygon(Point(4721, 1475), Point(4266, 1522), Point(3826, 3592), Point(4273, 3892)),

    redTeamBaseWalls = Polygon(Point(10112, 10950), Point(9743, 10769), Point(9248, 13076), Point(9652, 13151)),
    redTeamBaseWalls2 = Polygon(Point(12784, 9572), Point(10695, 10020), Point(10736, 10469), Point(12843, 10074)),

    jungleTopNearBaronPitWall = Polygon(Point(3866, 11580), Point(3209, 11265), Point(2503, 12089), Point(3144, 12798)),

    jungleBaronPitWall = Polygon(Point(4078, 9875), Point(3316, 10472), Point(3522, 11089), Point(4341, 10779)),
    jungleBaronPitWallExt1 = Polygon(Point(4341, 10779), Point(3522, 11089), Point(4197, 11392), Point(5288, 10865)),
    jungleBaronPitWallExt2 = Polygon(Point(5474, 9895), Point(5081, 10079), Point(4768, 10818), Point(5295, 10866)),
    jungleBaronPitWallExt3 = Polygon(Point(5287, 9183), Point(4387, 9633), Point(5080, 10081), Point(5474, 9897)),
    jungleBaronPitWallExt4 = Polygon(Point(5664, 9300), Point(5287, 9183), Point(5474, 9895), Point(5724, 9506)),

    jungleTopRedBuffWall = Polygon(Point(6396, 10722), Point(5819, 10559), Point(6145, 11152), Point(6570, 11214)),
    jungleTopRedBuffWallExt1 = Polygon(Point(6577, 9933), Point(5856, 10047), Point(5810, 10553), Point(6397, 10724)),
    jungleTopRedBuffWallExt2 = Polygon(Point(7328, 10192), Point(6577, 9933), Point(6457, 10460), Point(7281, 10809)),

    jungleTopNearRedBuffWall = Polygon(Point(7328, 10192), Point(6577, 9933), Point(6457, 10460), Point(7281, 10809)),
    jungleTopNearRedBuffWallExt1 = Polygon(Point(8262, 10912), Point(7795, 10764), Point(7063, 11363), Point(7727, 11642)),
    jungleTopNearRedBuffWallExt2 = Polygon(Point(8126, 10351), Point(7772, 10196), Point(7792, 10772), Point(8262, 10912)),

    jungleTopRedDoubleGolemsWall = Polygon(Point(5175, 11514), Point(4337, 11663), Point(4112, 12014), Point(5097, 11940)),
    jungleTopRedDoubleGolemsWallExt1 = Polygon(Point(5500, 11218), Point(5175, 11514), Point(5099, 11931), Point(5777, 12101)),
    jungleTopRedDoubleGolemsWallExt2 = Polygon(Point(6816, 11569), Point(5498, 11210), Point(5779, 12107), Point(5882, 11881)),
    jungleTopRedDoubleGolemsWallExt3 = Polygon(Point(6816, 11569), Point(5992, 11875), Point(6397, 12257), Point(6741, 12236)),

    jungleTopOuterWall1 = Polygon(Point(5135, 12334), Point(3788, 12518), Point(3689, 12868), Point(4909, 12971)),
    jungleTopOuterWall2 = Polygon(Point(6189, 12627), Point(5477, 12522), Point(5243, 12999), Point(6278, 12967)),
    jungleTopOuterWall3 = Polygon(Point(7143, 12444), Point(6482, 12670), Point(6550, 12959), Point(8139, 12909)),
    jungleTopOuterWall3Ext = Polygon(Point(8198, 12438), Point(7336, 12033), Point(7143, 12444), Point(8139, 12909)),

    jungleTopNearRedBaseWall = Polygon(Point(9028, 11337), Point(8400, 12135), Point(8497, 12898), Point(8961, 13036)),
    jungleTopNearRedBaseWallExt1 = Polygon(Point(9028, 11337), Point(8400, 12135), Point(8497, 12898), Point(8961, 13036)),
    jungleTopNearRedBaseWallExt2 = Polygon(Point(9023, 11337), Point(8546, 11161), Point(8163, 11920), Point(8400, 12135)),

    jungleTopWrathWall = Polygon(Point(7477, 9066), Point(6721, 9059), Point(6701, 9479), Point(6997, 9519)),
    jungleTopWrathWallExt1 = Polygon(Point(8166, 8934), Point(7551, 8463), Point(6721, 9059), Point(7477, 9066)),
    jungleTopWrathWallExt2 = Polygon(Point(8166, 8934), Point(7477, 9068), Point(7656, 9608), Point(8608, 9422)),
    jungleTopWrathWallExt3 = Polygon(Point(7981, 9544), Point(7657, 9608), Point(7760, 9921), Point(7936, 9883)),

    jungleTopNearMidOuterTurret1Wall = Polygon(Point(9544, 10456), Point(8800, 9763), Point(8616, 10798), Point(9147, 11000)),
    jungleTopNearMidOuterTurret1WallExt = Polygon(Point(8800, 9763), Point(8320, 9803), Point(8525, 10178), Point(8614, 10797)),


    redTopInhibTower = Polygon(Point(10424, 13350), Point(10102, 13350),Point(10102, 13647), Point(10424, 13647)),
    redTopInhib = Polygon(Point(11167, 13297), Point(10766, 13297), Point(10766, 13697), Point(11167, 13697)),

    redTopOuterTower1 = Polygon(Point(7696, 13068), Point(7368, 13068), Point(7368, 13350), Point(7696, 13350)),
    redTopOuterTower2 = Polygon(Point(4064, 13499), Point(3754, 13499), Point(3754, 13800), Point(4064, 13800)),

    blueTopOuterTower2 = Polygon(Point(682, 10073), Point(426, 10073), Point(426, 10386), Point(682, 10386)),
    blueTopOuterTower1 = Polygon(Point(1270, 6310), Point(961, 6310), Point(961, 6620), Point(1270, 6620)),

    blueTeamTopInhibTower = Polygon(Point(939, 3930), Point(623, 3930), Point(623, 4241), Point(939, 4241)),
    blueTeamTopInhib = Polygon(Point(1012, 3185), Point(632, 3185), Point(632, 3585), Point(1032, 3585)),

    blueTeamMidInhibTower = Polygon(Point(3382, 3321), Point(3081, 3321), Point(3081, 3607), Point(3382, 3607)),
    blueTeamMidInhib = Polygon(Point(2986, 2805), Point(2586, 2805), Point(2586, 3205), Point(2986, 3205)),

    blueTeamMidOuterTower1 = Polygon(Point(4769, 4471), Point(4483, 4471), Point(4483, 4737), Point(4769, 4737)),
    blueTeamMidOuterTower2 = Polygon(Point(5588, 6049), Point(5282, 6049), Point(5282, 6347), Point(5588, 6347)),

    redTeamMidOuterTower1 = Polygon(Point(8716, 8125), Point(8388, 8125), Point(8388, 8449), Point(8716, 8449)),
    redTeamMidOuterTower2 = Polygon(Point(9508, 9734), Point(9200, 9734), Point(9200, 10053), Point(9508, 10053)),

    redTeamMidInhibTower = Polygon(Point(10881, 10871), Point(10596, 10871), Point(10596, 11210), Point(10881, 11210)),
    redTeamMidInhib = Polygon(Point(11417, 11312), Point(11017, 11312), Point(11017, 11712), Point(11417, 11712)),

    blueTeamNearMidDecorationWall = Polygon(Point(2217, 3625), Point(1903, 3652), Point(1886, 3996), Point(2305, 3911)),
    redTeamNearMidDecorationWall = Polygon(Point(12150, 10547), Point(11775, 10567), Point(11830, 10942), Point(12065, 10836)),

}

-- Code ------------------------------------------------------------------------

class 'UnitPosition' -- {
function UnitPosition:againstWall(unit)
    unitPoint = Point(unit.x, unit.z)

    return mapRegions["leftBotLaneWall"]:contains(unitPoint)
            or mapRegions["centerBotLaneWall"]:contains(unitPoint)
            or mapRegions["rightBotLaneWall"]:contains(unitPoint)
            or mapRegions["leftTopBotLaneWall"]:contains(unitPoint)
            or mapRegions["centerTopBotLaneWall"]:contains(unitPoint)

            or mapRegions["leftTopLaneWall"]:contains(unitPoint)
            or mapRegions["centerTopLaneWall"]:contains(unitPoint)
            or mapRegions["centerTopLaneWallExt1"]:contains(unitPoint)
            or mapRegions["centerTopLaneWallExt2"]:contains(unitPoint)
            or mapRegions["centerTopLaneWallExt3"]:contains(unitPoint)

            or mapRegions["bottomOuterTurretWall"]:contains(unitPoint)
            or mapRegions["bottomOuterTurretWall2"]:contains(unitPoint)
            or mapRegions["bottomOuterTurretWall3"]:contains(unitPoint)
            or mapRegions["bottomOuterTurretWallExt"]:contains(unitPoint)

            or mapRegions["bottomOuterBlueTurret1"]:contains(unitPoint)
            or mapRegions["bottomOuterBlueTurret2"]:contains(unitPoint)

            or mapRegions["bottomOuterRedTurret1"]:contains(unitPoint)
            or mapRegions["bottomOuterRedTurret2"]:contains(unitPoint)

            or mapRegions["bottomBlueInhibTurret"]:contains(unitPoint)
            or mapRegions["bottomBlueInhib"]:contains(unitPoint)

            or mapRegions["bottomRedInhibTurret"]:contains(unitPoint)
            or mapRegions["bottomRedInhib"]:contains(unitPoint)

            or mapRegions["jungleRedNearBlueWall"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall1"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall2"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall3"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall3Ext"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall4"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall5Ext1"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall5Ext2"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall5Ext3"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall6"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall6Ext1"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall6Ext2"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall6Ext3"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall7"]:contains(unitPoint)
            or mapRegions["jungleRedNearBlueWall7Ext1"]:contains(unitPoint)

            or mapRegions["jungleRedNearWolvesWall1"]:contains(unitPoint)
            or mapRegions["jungleRedNearWolvesWall1Ext1"]:contains(unitPoint)
            or mapRegions["jungleRedNearWolvesWall1Ext2"]:contains(unitPoint)

            or mapRegions["jungleRedNearTurretWall1"]:contains(unitPoint)
            or mapRegions["jungleRedNearTurretWall1Ext1"]:contains(unitPoint)

            or mapRegions["jungleDragonPitWall"]:contains(unitPoint)
            or mapRegions["jungleDragonPitWallExt1"]:contains(unitPoint)
            or mapRegions["jungleDragonPitWallExt2"]:contains(unitPoint)
            or mapRegions["jungleDragonPitWallExt3"]:contains(unitPoint)
            or mapRegions["jungleDragonPitWallExt4"]:contains(unitPoint)
            or mapRegions["jungleDragonPitWallExt5"]:contains(unitPoint)

            or mapRegions["jungleBlueNearWrathsWall"]:contains(unitPoint)

            or mapRegions["jungleBlueNearRedWall"]:contains(unitPoint)
            or mapRegions["jungleBlueNearRedWallExt1"]:contains(unitPoint)
            or mapRegions["jungleBlueNearRedWallExt2"]:contains(unitPoint)

            or mapRegions["jungleBlueDoubleGolemsWall"]:contains(unitPoint)
            or mapRegions["jungleBlueDoubleGolemsWallExt1"]:contains(unitPoint)
            or mapRegions["jungleBlueDoubleGolemsWallExt2"]:contains(unitPoint)

            or mapRegions["jungleBlueNearOuterTurret1Wall"]:contains(unitPoint)
            or mapRegions["jungleBlueNearOuterTurret1WallExt"]:contains(unitPoint)

            or mapRegions["jungleBlueWrathWall"]:contains(unitPoint)
            or mapRegions["jungleBlueWrathWallExt1"]:contains(unitPoint)
            or mapRegions["jungleBlueWrathWallExt2"]:contains(unitPoint)
            or mapRegions["jungleBlueWrathWallExt3"]:contains(unitPoint)

            or mapRegions["leftRiverBotWall1"]:contains(unitPoint)
            or mapRegions["centerRiverBotWall2"]:contains(unitPoint)

            or mapRegions["jungleBlueBotWall1"]:contains(unitPoint)
            or mapRegions["jungleBlueBotWall2"]:contains(unitPoint)
            or mapRegions["jungleBlueNearRedWall1"]:contains(unitPoint)
            or mapRegions["jungleBlueNearRedWall1Ext1"]:contains(unitPoint)
            or mapRegions["jungleBlueNearRedWall1Ext2"]:contains(unitPoint)

            or mapRegions["blueTeamNexus"]:contains(unitPoint)
            or mapRegions["blueTeamNexusTurret1"]:contains(unitPoint)
            or mapRegions["blueTeamNexusTurret2"]:contains(unitPoint)

            or mapRegions["redTeamNexus"]:contains(unitPoint)
            or mapRegions["redTeamNexusTurret1"]:contains(unitPoint)
            or mapRegions["redTeamNexusTurret2"]:contains(unitPoint)

            or mapRegions["jungleBlueNearWolvesWall"]:contains(unitPoint)
            or mapRegions["jungleBlueNearWolvesWallExt1"]:contains(unitPoint)
            or mapRegions["jungleBlueNearWolvesWallExt2"]:contains(unitPoint)
            or mapRegions["jungleBlueNearWolvesWallExt3"]:contains(unitPoint)

            or mapRegions["jungleNearTopOuterTurret1Wall"]:contains(unitPoint)

            or mapRegions["jungleBlueWolvesWall"]:contains(unitPoint)
            or mapRegions["jungleBlueWolvesWallExt1"]:contains(unitPoint)
            or mapRegions["jungleBlueWolvesWallExt2"]:contains(unitPoint)

            or mapRegions["jungleBlueTeamBlueWall"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWallExt1"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWallExt2"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWall2"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWall3"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWall3Ext"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWall4"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWall5"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWall5Ext1"]:contains(unitPoint)
            or mapRegions["jungleBlueTeamBlueWall5Ext2"]:contains(unitPoint)

            or mapRegions["jungleNearBlueOuterTurret1Wall"]:contains(unitPoint)
            or mapRegions["jungleNearBlueOuterTurret1WallExt"]:contains(unitPoint)

            or mapRegions["leftTopRiverWallNearMid"]:contains(unitPoint)
            or mapRegions["rightTopRiverWallNearMid"]:contains(unitPoint)

            or mapRegions["blueTeamBaseWalls"]:contains(unitPoint)
            or mapRegions["blueTeamBaseWalls2"]:contains(unitPoint)

            or mapRegions["redTeamBaseWalls"]:contains(unitPoint)
            or mapRegions["redTeamBaseWalls2"]:contains(unitPoint)

            or mapRegions["jungleTopNearBaronPitWall"]:contains(unitPoint)

            or mapRegions["jungleBaronPitWall"]:contains(unitPoint)
            or mapRegions["jungleBaronPitWallExt1"]:contains(unitPoint)
            or mapRegions["jungleBaronPitWallExt2"]:contains(unitPoint)
            or mapRegions["jungleBaronPitWallExt3"]:contains(unitPoint)
            or mapRegions["jungleBaronPitWallExt4"]:contains(unitPoint)

            or mapRegions["jungleTopRedBuffWall"]:contains(unitPoint)
            or mapRegions["jungleTopRedBuffWallExt1"]:contains(unitPoint)
            or mapRegions["jungleTopRedBuffWallExt2"]:contains(unitPoint)

            or mapRegions["jungleTopNearRedBuffWall"]:contains(unitPoint)
            or mapRegions["jungleTopNearRedBuffWallExt1"]:contains(unitPoint)
            or mapRegions["jungleTopNearRedBuffWallExt2"]:contains(unitPoint)

            or mapRegions["jungleTopRedDoubleGolemsWall"]:contains(unitPoint)
            or mapRegions["jungleTopRedDoubleGolemsWallExt1"]:contains(unitPoint)
            or mapRegions["jungleTopRedDoubleGolemsWallExt2"]:contains(unitPoint)
            or mapRegions["jungleTopRedDoubleGolemsWallExt3"]:contains(unitPoint)

            or mapRegions["jungleTopOuterWall1"]:contains(unitPoint)
            or mapRegions["jungleTopOuterWall2"]:contains(unitPoint)
            or mapRegions["jungleTopOuterWall3"]:contains(unitPoint)
            or mapRegions["jungleTopOuterWall3Ext"]:contains(unitPoint)

            or mapRegions["jungleTopNearRedBaseWall"]:contains(unitPoint)
            or mapRegions["jungleTopNearRedBaseWallExt1"]:contains(unitPoint)
            or mapRegions["jungleTopNearRedBaseWallExt2"]:contains(unitPoint)

            or mapRegions["jungleTopWrathWall"]:contains(unitPoint)
            or mapRegions["jungleTopWrathWallExt1"]:contains(unitPoint)
            or mapRegions["jungleTopWrathWallExt2"]:contains(unitPoint)
            or mapRegions["jungleTopWrathWallExt3"]:contains(unitPoint)

            or mapRegions["jungleTopNearMidOuterTurret1Wall"]:contains(unitPoint)
            or mapRegions["jungleTopNearMidOuterTurret1WallExt"]:contains(unitPoint)

            or mapRegions["redTopInhibTower"]:contains(unitPoint)
            or mapRegions["redTopInhib"]:contains(unitPoint)

            or mapRegions["redTopOuterTower1"]:contains(unitPoint)
            or mapRegions["redTopOuterTower2"]:contains(unitPoint)

            or mapRegions["blueTopOuterTower2"]:contains(unitPoint)
            or mapRegions["blueTopOuterTower1"]:contains(unitPoint)

            or mapRegions["blueTeamTopInhibTower"]:contains(unitPoint)
            or mapRegions["blueTeamTopInhib"]:contains(unitPoint)

            or mapRegions["blueTeamMidInhibTower"]:contains(unitPoint)
            or mapRegions["blueTeamMidInhib"]:contains(unitPoint)

            or mapRegions["blueTeamMidOuterTower1"]:contains(unitPoint)
            or mapRegions["blueTeamMidOuterTower2"]:contains(unitPoint)

            or mapRegions["redTeamMidOuterTower1"]:contains(unitPoint)
            or mapRegions["redTeamMidOuterTower2"]:contains(unitPoint)

            or mapRegions["redTeamMidInhibTower"]:contains(unitPoint)
            or mapRegions["redTeamMidInhib"]:contains(unitPoint)

            or mapRegions["blueTeamNearMidDecorationWall"]:contains(unitPoint)
            or mapRegions["redTeamNearMidDecorationWall"]:contains(unitPoint)
end

--UPDATEURL=
--HASH=3D42271192E5C6E5EB48FA7CD2CC199A
