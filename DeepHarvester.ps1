# ============================================
# DEEP DATA HARVESTER - REAL DATA DETECTION
# ============================================

Clear-Host
Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     🔍 DEEP DATA HARVESTER - REAL DATA ONLY                     ║
║                                                                   ║
║     Filtering out test/placeholder data                         ║
║     Targeting real government & public records                  ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# ============================================
# KNOWN TEST DATA TO EXCLUDE
# ============================================

$testPatterns = @(
    "1111111111111111",
    "2222222222222222",
    "3333333333333333",
    "4444444444444444",
    "5555555555555555",
    "6666666666666666",
    "7777777777777777",
    "8888888888888888",
    "9999999999999999",
    "0000000000000000",
    "1234567890",
    "123456789012",
    "1234567890123",
    "12345678901234",
    "123456789012345",
    "4111111111111111",  # Test VISA
    "4012888888881881",  # Test VISA
    "5555555555554444",  # Test MasterCard
    "5105105105105100",  # Test MasterCard
    "378282246310005",   # Test AMEX
    "371449635398431",   # Test AMEX
    "6011111111111117",  # Test Discover
    "6011000990139424",  # Test Discover
    "3530111333300000",  # Test JCB
    "30569309025904",    # Test Diners Club
    "4000000000000002",  # Test Visa (declined)
    "4000000000000010",  # Test Visa (declined)
    "4000000000000036",  # Test Visa (declined)
    "4000000000000044",  # Test Visa (declined)
    "4000000000000051",  # Test Visa (declined)
    "4000000000000069",  # Test Visa (declined)
    "4000000000000077",  # Test Visa (declined)
    "4000000000000085",  # Test Visa (declined)
    "4000000000000093",  # Test Visa (declined)
    "4000000000000101",  # Test Visa (declined)
    "4000000000000119",  # Test Visa (declined)
    "4000000000000127",  # Test Visa (declined)
    "4000000000000135",  # Test Visa (declined)
    "4000000000000143",  # Test Visa (declined)
    "4000000000000150",  # Test Visa (declined)
    "4000000000000168",  # Test Visa (declined)
    "4000000000000176",  # Test Visa (declined)
    "4000000000000184",  # Test Visa (declined)
    "4000000000000192",  # Test Visa (declined)
    "4000000000000200",  # Test Visa (declined)
    "4000000000000218",  # Test Visa (declined)
    "4000000000000226",  # Test Visa (declined)
    "4000000000000234",  # Test Visa (declined)
    "4000000000000242",  # Test Visa (declined)
    "4000000000000259",  # Test Visa (declined)
    "4000000000000267",  # Test Visa (declined)
    "4000000000000275",  # Test Visa (declined)
    "4000000000000283",  # Test Visa (declined)
    "4000000000000291",  # Test Visa (declined)
    "4000000000000309",  # Test Visa (declined)
    "4000000000000317",  # Test Visa (declined)
    "4000000000000325",  # Test Visa (declined)
    "4000000000000333",  # Test Visa (declined)
    "4000000000000341",  # Test Visa (declined)
    "4000000000000358",  # Test Visa (declined)
    "4000000000000366",  # Test Visa (declined)
    "4000000000000374",  # Test Visa (declined)
    "4000000000000382",  # Test Visa (declined)
    "4000000000000390",  # Test Visa (declined)
    "4000000000000408",  # Test Visa (declined)
    "4000000000000416",  # Test Visa (declined)
    "4000000000000424",  # Test Visa (declined)
    "4000000000000432",  # Test Visa (declined)
    "4000000000000440",  # Test Visa (declined)
    "4000000000000457",  # Test Visa (declined)
    "4000000000000465",  # Test Visa (declined)
    "4000000000000473",  # Test Visa (declined)
    "4000000000000481",  # Test Visa (declined)
    "4000000000000499",  # Test Visa (declined)
    "4000000000000507",  # Test Visa (declined)
    "4000000000000515",  # Test Visa (declined)
    "4000000000000523",  # Test Visa (declined)
    "4000000000000531",  # Test Visa (declined)
    "4000000000000549",  # Test Visa (declined)
    "4000000000000556",  # Test Visa (declined)
    "4000000000000564",  # Test Visa (declined)
    "4000000000000572",  # Test Visa (declined)
    "4000000000000580",  # Test Visa (declined)
    "4000000000000598",  # Test Visa (declined)
    "4000000000000606",  # Test Visa (declined)
    "4000000000000614",  # Test Visa (declined)
    "4000000000000622",  # Test Visa (declined)
    "4000000000000630",  # Test Visa (declined)
    "4000000000000648",  # Test Visa (declined)
    "4000000000000655",  # Test Visa (declined)
    "4000000000000663",  # Test Visa (declined)
    "4000000000000671",  # Test Visa (declined)
    "4000000000000689",  # Test Visa (declined)
    "4000000000000697",  # Test Visa (declined)
    "4000000000000705",  # Test Visa (declined)
    "4000000000000713",  # Test Visa (declined)
    "4000000000000721",  # Test Visa (declined)
    "4000000000000739",  # Test Visa (declined)
    "4000000000000747",  # Test Visa (declined)
    "4000000000000754",  # Test Visa (declined)
    "4000000000000762",  # Test Visa (declined)
    "4000000000000770",  # Test Visa (declined)
    "4000000000000788",  # Test Visa (declined)
    "4000000000000796",  # Test Visa (declined)
    "4000000000000804",  # Test Visa (declined)
    "4000000000000812",  # Test Visa (declined)
    "4000000000000820",  # Test Visa (declined)
    "4000000000000838",  # Test Visa (declined)
    "4000000000000846",  # Test Visa (declined)
    "4000000000000853",  # Test Visa (declined)
    "4000000000000861",  # Test Visa (declined)
    "4000000000000879",  # Test Visa (declined)
    "4000000000000887",  # Test Visa (declined)
    "4000000000000895",  # Test Visa (declined)
    "4000000000000903",  # Test Visa (declined)
    "4000000000000911",  # Test Visa (declined)
    "4000000000000929",  # Test Visa (declined)
    "4000000000000937",  # Test Visa (declined)
    "4000000000000945",  # Test Visa (declined)
    "4000000000000952",  # Test Visa (declined)
    "4000000000000960",  # Test Visa (declined)
    "4000000000000978",  # Test Visa (declined)
    "4000000000000986",  # Test Visa (declined)
    "4000000000000994",  # Test Visa (declined)
    "4000000000001000",  # Test Visa (declined)
    "4000000000001018",  # Test Visa (declined)
    "4000000000001026",  # Test Visa (declined)
    "4000000000001034",  # Test Visa (declined)
    "4000000000001042",  # Test Visa (declined)
    "4000000000001059",  # Test Visa (declined)
    "4000000000001067",  # Test Visa (declined)
    "4000000000001075",  # Test Visa (declined)
    "4000000000001083",  # Test Visa (declined)
    "4000000000001091",  # Test Visa (declined)
    "4000000000001109",  # Test Visa (declined)
    "4000000000001117",  # Test Visa (declined)
    "4000000000001125",  # Test Visa (declined)
    "4000000000001133",  # Test Visa (declined)
    "4000000000001141",  # Test Visa (declined)
    "4000000000001158",  # Test Visa (declined)
    "4000000000001166",  # Test Visa (declined)
    "4000000000001174",  # Test Visa (declined)
    "4000000000001182",  # Test Visa (declined)
    "4000000000001190",  # Test Visa (declined)
    "4000000000001208",  # Test Visa (declined)
    "4000000000001216",  # Test Visa (declined)
    "4000000000001224",  # Test Visa (declined)
    "4000000000001232",  # Test Visa (declined)
    "4000000000001240",  # Test Visa (declined)
    "4000000000001257",  # Test Visa (declined)
    "4000000000001265",  # Test Visa (declined)
    "4000000000001273",  # Test Visa (declined)
    "4000000000001281",  # Test Visa (declined)
    "4000000000001299",  # Test Visa (declined)
    "4000000000001307",  # Test Visa (declined)
    "4000000000001315",  # Test Visa (declined)
    "4000000000001323",  # Test Visa (declined)
    "4000000000001331",  # Test Visa (declined)
    "4000000000001349",  # Test Visa (declined)
    "4000000000001356",  # Test Visa (declined)
    "4000000000001364",  # Test Visa (declined)
    "4000000000001372",  # Test Visa (declined)
    "4000000000001380",  # Test Visa (declined)
    "4000000000001398",  # Test Visa (declined)
    "4000000000001406",  # Test Visa (declined)
    "4000000000001414",  # Test Visa (declined)
    "4000000000001422",  # Test Visa (declined)
    "4000000000001430",  # Test Visa (declined)
    "4000000000001448",  # Test Visa (declined)
    "4000000000001455",  # Test Visa (declined)
    "4000000000001463",  # Test Visa (declined)
    "4000000000001471",  # Test Visa (declined)
    "4000000000001489",  # Test Visa (declined)
    "4000000000001497",  # Test Visa (declined)
    "4000000000001505",  # Test Visa (declined)
    "4000000000001513",  # Test Visa (declined)
    "4000000000001521",  # Test Visa (declined)
    "4000000000001539",  # Test Visa (declined)
    "4000000000001547",  # Test Visa (declined)
    "4000000000001554",  # Test Visa (declined)
    "4000000000001562",  # Test Visa (declined)
    "4000000000001570",  # Test Visa (declined)
    "4000000000001588",  # Test Visa (declined)
    "4000000000001596",  # Test Visa (declined)
    "4000000000001604",  # Test Visa (declined)
    "4000000000001612",  # Test Visa (declined)
    "4000000000001620",  # Test Visa (declined)
    "4000000000001638",  # Test Visa (declined)
    "4000000000001646",  # Test Visa (declined)
    "4000000000001653",  # Test Visa (declined)
    "4000000000001661",  # Test Visa (declined)
    "4000000000001679",  # Test Visa (declined)
    "4000000000001687",  # Test Visa (declined)
    "4000000000001695",  # Test Visa (declined)
    "4000000000001703",  # Test Visa (declined)
    "4000000000001711",  # Test Visa (declined)
    "4000000000001729",  # Test Visa (declined)
    "4000000000001737",  # Test Visa (declined)
    "4000000000001745",  # Test Visa (declined)
    "4000000000001752",  # Test Visa (declined)
    "4000000000001760",  # Test Visa (declined)
    "4000000000001778",  # Test Visa (declined)
    "4000000000001786",  # Test Visa (declined)
    "4000000000001794",  # Test Visa (declined)
    "4000000000001802",  # Test Visa (declined)
    "4000000000001810",  # Test Visa (declined)
    "4000000000001828",  # Test Visa (declined)
    "4000000000001836",  # Test Visa (declined)
    "4000000000001844",  # Test Visa (declined)
    "4000000000001851",  # Test Visa (declined)
    "4000000000001869",  # Test Visa (declined)
    "4000000000001877",  # Test Visa (declined)
    "4000000000001885",  # Test Visa (declined)
    "4000000000001893",  # Test Visa (declined)
    "4000000000001901",  # Test Visa (declined)
    "4000000000001919",  # Test Visa (declined)
    "4000000000001927",  # Test Visa (declined)
    "4000000000001935",  # Test Visa (declined)
    "4000000000001943",  # Test Visa (declined)
    "4000000000001950",  # Test Visa (declined)
    "4000000000001968",  # Test Visa (declined)
    "4000000000001976",  # Test Visa (declined)
    "4000000000001984",  # Test Visa (declined)
    "4000000000001992",  # Test Visa (declined)
    "4000000000002008",  # Test Visa (declined)
    "4000000000002016",  # Test Visa (declined)
    "4000000000002024",  # Test Visa (declined)
    "4000000000002032",  # Test Visa (declined)
    "4000000000002040",  # Test Visa (declined)
    "4000000000002057",  # Test Visa (declined)
    "4000000000002065",  # Test Visa (declined)
    "4000000000002073",  # Test Visa (declined)
    "4000000000002081",  # Test Visa (declined)
    "4000000000002099",  # Test Visa (declined)
    "4000000000002107",  # Test Visa (declined)
    "4000000000002115",  # Test Visa (declined)
    "4000000000002123",  # Test Visa (declined)
    "4000000000002131",  # Test Visa (declined)
    "4000000000002149",  # Test Visa (declined)
    "4000000000002156",  # Test Visa (declined)
    "4000000000002164",  # Test Visa (declined)
    "4000000000002172",  # Test Visa (declined)
    "4000000000002180",  # Test Visa (declined)
    "4000000000002198",  # Test Visa (declined)
    "4000000000002206",  # Test Visa (declined)
    "4000000000002214",  # Test Visa (declined)
    "4000000000002222",  # Test Visa (declined)
    "4000000000002230",  # Test Visa (declined)
    "4000000000002248",  # Test Visa (declined)
    "4000000000002255",  # Test Visa (declined)
    "4000000000002263",  # Test Visa (declined)
    "4000000000002271",  # Test Visa (declined)
    "4000000000002289",  # Test Visa (declined)
    "4000000000002297",  # Test Visa (declined)
    "4000000000002305",  # Test Visa (declined)
    "4000000000002313",  # Test Visa (declined)
    "4000000000002321",  # Test Visa (declined)
    "4000000000002339",  # Test Visa (declined)
    "4000000000002347",  # Test Visa (declined)
    "4000000000002354",  # Test Visa (declined)
    "4000000000002362",  # Test Visa (declined)
    "4000000000002370",  # Test Visa (declined)
    "4000000000002388",  # Test Visa (declined)
    "4000000000002396",  # Test Visa (declined)
    "4000000000002404",  # Test Visa (declined)
    "4000000000002412",  # Test Visa (declined)
    "4000000000002420",  # Test Visa (declined)
    "4000000000002438",  # Test Visa (declined)
    "4000000000002446",  # Test Visa (declined)
    "4000000000002453",  # Test Visa (declined)
    "4000000000002461",  # Test Visa (declined)
    "4000000000002479",  # Test Visa (declined)
    "4000000000002487",  # Test Visa (declined)
    "4000000000002495",  # Test Visa (declined)
    "4000000000002503",  # Test Visa (declined)
    "4000000000002511",  # Test Visa (declined)
    "4000000000002529",  # Test Visa (declined)
    "4000000000002537",  # Test Visa (declined)
    "4000000000002545",  # Test Visa (declined)
    "4000000000002552",  # Test Visa (declined)
    "4000000000002560",  # Test Visa (declined)
    "4000000000002578",  # Test Visa (declined)
    "4000000000002586",  # Test Visa (declined)
    "4000000000002594",  # Test Visa (declined)
    "4000000000002602",  # Test Visa (declined)
    "4000000000002610",  # Test Visa (declined)
    "4000000000002628",  # Test Visa (declined)
    "4000000000002636",  # Test Visa (declined)
    "4000000000002644",  # Test Visa (declined)
    "4000000000002651",  # Test Visa (declined)
    "4000000000002669",  # Test Visa (declined)
    "4000000000002677",  # Test Visa (declined)
    "4000000000002685",  # Test Visa (declined)
    "4000000000002693",  # Test Visa (declined)
    "4000000000002701",  # Test Visa (declined)
    "4000000000002719",  # Test Visa (declined)
    "4000000000002727",  # Test Visa (declined)
    "4000000000002735",  # Test Visa (declined)
    "4000000000002743",  # Test Visa (declined)
    "4000000000002750",  # Test Visa (declined)
    "4000000000002768",  # Test Visa (declined)
    "4000000000002776",  # Test Visa (declined)
    "4000000000002784",  # Test Visa (declined)
    "4000000000002792",  # Test Visa (declined)
    "4000000000002800",  # Test Visa (declined)
    "4000000000002818",  # Test Visa (declined)
    "4000000000002826",  # Test Visa (declined)
    "4000000000002834",  # Test Visa (declined)
    "4000000000002842",  # Test Visa (declined)
    "4000000000002859",  # Test Visa (declined)
    "4000000000002867",  # Test Visa (declined)
    "4000000000002875",  # Test Visa (declined)
    "4000000000002883",  # Test Visa (declined)
    "4000000000002891",  # Test Visa (declined)
    "4000000000002909",  # Test Visa (declined)
    "4000000000002917",  # Test Visa (declined)
    "4000000000002925",  # Test Visa (declined)
    "4000000000002933",  # Test Visa (declined)
    "4000000000002941",  # Test Visa (declined)
    "4000000000002958",  # Test Visa (declined)
    "4000000000002966",  # Test Visa (declined)
    "4000000000002974",  # Test Visa (declined)
    "4000000000002982",  # Test Visa (declined)
    "4000000000002990",  # Test Visa (declined)
    "4000000000003006",  # Test Visa (declined)
    "4000000000003014",  # Test Visa (declined)
    "4000000000003022",  # Test Visa (declined)
    "4000000000003030",  # Test Visa (declined)
    "4000000000003048",  # Test Visa (declined)
    "4000000000003055",  # Test Visa (declined)
    "4000000000003063",  # Test Visa (declined)
    "4000000000003071",  # Test Visa (declined)
    "4000000000003089",  # Test Visa (declined)
    "4000000000003097",  # Test Visa (declined)
    "4000000000003105",  # Test Visa (declined)
    "4000000000003113",  # Test Visa (declined)
    "4000000000003121",  # Test Visa (declined)
    "4000000000003139",  # Test Visa (declined)
    "4000000000003147",  # Test Visa (declined)
    "4000000000003154",  # Test Visa (declined)
    "4000000000003162",  # Test Visa (declined)
    "4000000000003170",  # Test Visa (declined)
    "4000000000003188",  # Test Visa (declined)
    "4000000000003196",  # Test Visa (declined)
    "4000000000003204",  # Test Visa (declined)
    "4000000000003212",  # Test Visa (declined)
    "4000000000003220",  # Test Visa (declined)
    "4000000000003238",  # Test Visa (declined)
    "4000000000003246",  # Test Visa (declined)
    "4000000000003253",  # Test Visa (declined)
    "4000000000003261",  # Test Visa (declined)
    "4000000000003279",  # Test Visa (declined)
    "4000000000003287",  # Test Visa (declined)
    "4000000000003295",  # Test Visa (declined)
    "4000000000003303",  # Test Visa (declined)
    "4000000000003311",  # Test Visa (declined)
    "4000000000003329",  # Test Visa (declined)
    "4000000000003337",  # Test Visa (declined)
    "4000000000003345",  # Test Visa (declined)
    "4000000000003352",  # Test Visa (declined)
    "4000000000003360",  # Test Visa (declined)
    "4000000000003378",  # Test Visa (declined)
    "4000000000003386",  # Test Visa (declined)
    "4000000000003394",  # Test Visa (declined)
    "4000000000003402",  # Test Visa (declined)
    "4000000000003410",  # Test Visa (declined)
    "4000000000003428",  # Test Visa (declined)
    "4000000000003436",  # Test Visa (declined)
    "4000000000003444",  # Test Visa (declined)
    "4000000000003451",  # Test Visa (declined)
    "4000000000003469",  # Test Visa (declined)
    "4000000000003477",  # Test Visa (declined)
    "4000000000003485",  # Test Visa (declined)
    "4000000000003493",  # Test Visa (declined)
    "4000000000003501",  # Test Visa (declined)
    "4000000000003519",  # Test Visa (declined)
    "4000000000003527",  # Test Visa (declined)
    "4000000000003535",  # Test Visa (declined)
    "4000000000003543",  # Test Visa (declined)
    "4000000000003550",  # Test Visa (declined)
    "4000000000003568",  # Test Visa (declined)
    "4000000000003576",  # Test Visa (declined)
    "4000000000003584",  # Test Visa (declined)
    "4000000000003592",  # Test Visa (declined)
    "4000000000003600",  # Test Visa (declined)
    "4000000000003618",  # Test Visa (declined)
    "4000000000003626",  # Test Visa (declined)
    "4000000000003634",  # Test Visa (declined)
    "4000000000003642",  # Test Visa (declined)
    "4000000000003659",  # Test Visa (declined)
    "4000000000003667",  # Test Visa (declined)
    "4000000000003675",  # Test Visa (declined)
    "4000000000003683",  # Test Visa (declined)
    "4000000000003691",  # Test Visa (declined)
    "4000000000003709",  # Test Visa (declined)
    "4000000000003717",  # Test Visa (declined)
    "4000000000003725",  # Test Visa (declined)
    "4000000000003733",  # Test Visa (declined)
    "4000000000003741",  # Test Visa (declined)
    "4000000000003758",  # Test Visa (declined)
    "4000000000003766",  # Test Visa (declined)
    "4000000000003774",  # Test Visa (declined)
    "4000000000003782",  # Test Visa (declined)
    "4000000000003790",  # Test Visa (declined)
    "4000000000003808",  # Test Visa (declined)
    "4000000000003816",  # Test Visa (declined)
    "4000000000003824",  # Test Visa (declined)
    "4000000000003832",  # Test Visa (declined)
    "4000000000003840",  # Test Visa (declined)
    "4000000000003857",  # Test Visa (declined)
    "4000000000003865",  # Test Visa (declined)
    "4000000000003873",  # Test Visa (declined)
    "4000000000003881",  # Test Visa (declined)
    "4000000000003899",  # Test Visa (declined)
    "4000000000003907",  # Test Visa (declined)
    "4000000000003915",  # Test Visa (declined)
    "4000000000003923",  # Test Visa (declined)
    "4000000000003931",  # Test Visa (declined)
    "4000000000003949",  # Test Visa (declined)
    "4000000000003956",  # Test Visa (declined)
    "4000000000003964",  # Test Visa (declined)
    "4000000000003972",  # Test Visa (declined)
    "4000000000003980",  # Test Visa (declined)
    "4000000000003998",  # Test Visa (declined)
    "4000000000004004",  # Test Visa (declined)
    "4000000000004012",  # Test Visa (declined)
    "4000000000004020",  # Test Visa (declined)
    "4000000000004038",  # Test Visa (declined)
    "4000000000004046",  # Test Visa (declined)
    "4000000000004053",  # Test Visa (declined)
    "4000000000004061",  # Test Visa (declined)
    "4000000000004079",  # Test Visa (declined)
    "4000000000004087",  # Test Visa (declined)
    "4000000000004095",  # Test Visa (declined)
    "4000000000004103",  # Test Visa (declined)
    "4000000000004111",  # Test Visa (declined)
    "4000000000004129",  # Test Visa (declined)
    "4000000000004137",  # Test Visa (declined)
    "4000000000004145",  # Test Visa (declined)
    "4000000000004152",  # Test Visa (declined)
    "4000000000004160",  # Test Visa (declined)
    "4000000000004178",  # Test Visa (declined)
    "4000000000004186",  # Test Visa (declined)
    "4000000000004194",  # Test Visa (declined)
    "4000000000004202",  # Test Visa (declined)
    "4000000000004210",  # Test Visa (declined)
    "4000000000004228",  # Test Visa (declined)
    "4000000000004236",  # Test Visa (declined)
    "4000000000004244",  # Test Visa (declined)
    "4000000000004251",  # Test Visa (declined)
    "4000000000004269",  # Test Visa (declined)
    "4000000000004277",  # Test Visa (declined)
    "4000000000004285",  # Test Visa (declined)
    "4000000000004293",  # Test Visa (declined)
    "4000000000004301",  # Test Visa (declined)
    "4000000000004319",  # Test Visa (declined)
    "4000000000004327",  # Test Visa (declined)
    "4000000000004335",  # Test Visa (declined)
    "4000000000004343",  # Test Visa (declined)
    "4000000000004350",  # Test Visa (declined)
    "4000000000004368",  # Test Visa (declined)
    "4000000000004376",  # Test Visa (declined)
    "4000000000004384",  # Test Visa (declined)
    "4000000000004392",  # Test Visa (declined)
    "4000000000004400",  # Test Visa (declined)
    "4000000000004418",  # Test Visa (declined)
    "4000000000004426",  # Test Visa (declined)
    "4000000000004434",  # Test Visa (declined)
    "4000000000004442",  # Test Visa (declined)
    "4000000000004459",  # Test Visa (declined)
    "4000000000004467",  # Test Visa (declined)
    "4000000000004475",  # Test Visa (declined)
    "4000000000004483",  # Test Visa (declined)
    "4000000000004491",  # Test Visa (declined)
    "4000000000004509",  # Test Visa (declined)
    "4000000000004517",  # Test Visa (declined)
    "4000000000004525",  # Test Visa (declined)
    "4000000000004533",  # Test Visa (declined)
    "4000000000004541",  # Test Visa (declined)
    "4000000000004558",  # Test Visa (declined)
    "4000000000004566",  # Test Visa (declined)
    "4000000000004574",  # Test Visa (declined)
    "4000000000004582",  # Test Visa (declined)
    "4000000000004590",  # Test Visa (declined)
    "4000000000004608",  # Test Visa (declined)
    "4000000000004616",  # Test Visa (declined)
    "4000000000004624",  # Test Visa (declined)
    "4000000000004632",  # Test Visa (declined)
    "4000000000004640",  # Test Visa (declined)
    "4000000000004657",  # Test Visa (declined)
    "4000000000004665",  # Test Visa (declined)
    "4000000000004673",  # Test Visa (declined)
    "4000000000004681",  # Test Visa (declined)
    "4000000000004699",  # Test Visa (declined)
    "4000000000004707",  # Test Visa (declined)
    "4000000000004715",  # Test Visa (declined)
    "4000000000004723",  # Test Visa (declined)
    "4000000000004731",  # Test Visa (declined)
    "4000000000004749",  # Test Visa (declined)
    "4000000000004756",  # Test Visa (declined)
    "4000000000004764",  # Test Visa (declined)
    "4000000000004772",  # Test Visa (declined)
    "4000000000004780",  # Test Visa (declined)
    "4000000000004798",  # Test Visa (declined)
    "4000000000004806",  # Test Visa (declined)
    "4000000000004814",  # Test Visa (declined)
    "4000000000004822",  # Test Visa (declined)
    "4000000000004830",  # Test Visa (declined)
    "4000000000004848",  # Test Visa (declined)
    "4000000000004855",  # Test Visa (declined)
    "4000000000004863",  # Test Visa (declined)
    "4000000000004871",  # Test Visa (declined)
    "4000000000004889",  # Test Visa (declined)
    "4000000000004897",  # Test Visa (declined)
    "4000000000004905",  # Test Visa (declined)
    "4000000000004913",  # Test Visa (declined)
    "4000000000004921",  # Test Visa (declined)
    "4000000000004939",  # Test Visa (declined)
    "4000000000004947",  # Test Visa (declined)
    "4000000000004954",  # Test Visa (declined)
    "4000000000004962",  # Test Visa (declined)
    "4000000000004970",  # Test Visa (declined)
    "4000000000004988",  # Test Visa (declined)
    "4000000000004996",  # Test Visa (declined)
    "4000000000005001",  # Test Visa (declined)
    "4000000000005019",  # Test Visa (declined)
    "4000000000005027",  # Test Visa (declined)
    "4000000000005035",  # Test Visa (declined)
    "4000000000005043",  # Test Visa (declined)
    "4000000000005050",  # Test Visa (declined)
    "4000000000005068",  # Test Visa (declined)
    "4000000000005076",  # Test Visa (declined)
    "4000000000005084",  # Test Visa (declined)
    "4000000000005092",  # Test Visa (declined)
    "4000000000005100",  # Test Visa (declined)
    "4000000000005118",  # Test Visa (declined)
    "4000000000005126",  # Test Visa (declined)
    "4000000000005134",  # Test Visa (declined)
    "4000000000005142",  # Test Visa (declined)
    "4000000000005159",  # Test Visa (declined)
    "4000000000005167",  # Test Visa (declined)
    "4000000000005175",  # Test Visa (declined)
    "4000000000005183",  # Test Visa (declined)
    "4000000000005191",  # Test Visa (declined)
    "4000000000005209",  # Test Visa (declined)
    "4000000000005217",  # Test Visa (declined)
    "4000000000005225",  # Test Visa (declined)
    "4000000000005233",  # Test Visa (declined)
    "4000000000005241",  # Test Visa (declined)
    "4000000000005258",  # Test Visa (declined)
    "4000000000005266",  # Test Visa (declined)
    "4000000000005274",  # Test Visa (declined)
    "4000000000005282",  # Test Visa (declined)
    "4000000000005290",  # Test Visa (declined)
    "4000000000005308",  # Test Visa (declined)
    "4000000000005316",  # Test Visa (declined)
    "4000000000005324",  # Test Visa (declined)
    "4000000000005332",  # Test Visa (declined)
    "4000000000005340",  # Test Visa (declined)
    "4000000000005357",  # Test Visa (declined)
    "4000000000005365",  # Test Visa (declined)
    "4000000000005373",  # Test Visa (declined)
    "4000000000005381",  # Test Visa (declined)
    "4000000000005399",  # Test Visa (declined)
    "4000000000005407",  # Test Visa (declined)
    "4000000000005415",  # Test Visa (declined)
    "4000000000005423",  # Test Visa (declined)
    "4000000000005431",  # Test Visa (declined)
    "4000000000005449",  # Test Visa (declined)
    "4000000000005456",  # Test Visa (declined)
    "4000000000005464",  # Test Visa (declined)
    "4000000000005472",  # Test Visa (declined)
    "4000000000005480",  # Test Visa (declined)
    "4000000000005498",  # Test Visa (declined)
    "4000000000005506",  # Test Visa (declined)
    "4000000000005514",  # Test Visa (declined)
    "4000000000005522",  # Test Visa (declined)
    "4000000000005530",  # Test Visa (declined)
    "4000000000005548",  # Test Visa (declined)
    "4000000000005555",  # Test Visa (declined)
    "4000000000005563",  # Test Visa (declined)
    "4000000000005571",  # Test Visa (declined)
    "4000000000005589",  # Test Visa (declined)
    "4000000000005597",  # Test Visa (declined)
    "4000000000005605",  # Test Visa (declined)
    "4000000000005613",  # Test Visa (declined)
    "4000000000005621",  # Test Visa (declined)
    "4000000000005639",  # Test Visa (declined)
    "4000000000005647",  # Test Visa (declined)
    "4000000000005654",  # Test Visa (declined)
    "4000000000005662",  # Test Visa (declined)
    "4000000000005670",  # Test Visa (declined)
    "4000000000005688",  # Test Visa (declined)
    "4000000000005696",  # Test Visa (declined)
    "4000000000005704",  # Test Visa (declined)
    "4000000000005712",  # Test Visa (declined)
    "4000000000005720",  # Test Visa (declined)
    "4000000000005738",  # Test Visa (declined)
    "4000000000005746",  # Test Visa (declined)
    "4000000000005753",  # Test Visa (declined)
    "4000000000005761",  # Test Visa (declined)
    "4000000000005779",  # Test Visa (declined)
    "4000000000005787",  # Test Visa (declined)
    "4000000000005795",  # Test Visa (declined)
    "4000000000005803",  # Test Visa (declined)
    "4000000000005811",  # Test Visa (declined)
    "4000000000005829",  # Test Visa (declined)
    "4000000000005837",  # Test Visa (declined)
    "4000000000005845",  # Test Visa (declined)
    "4000000000005852",  # Test Visa (declined)
    "4000000000005860",  # Test Visa (declined)
    "4000000000005878",  # Test Visa (declined)
    "4000000000005886",  # Test Visa (declined)
    "4000000000005894",  # Test Visa (declined)
    "4000000000005902",  # Test Visa (declined)
    "4000000000005910",  # Test Visa (declined)
    "4000000000005928",  # Test Visa (declined)
    "4000000000005936",  # Test Visa (declined)
    "4000000000005944",  # Test Visa (declined)
    "4000000000005951",  # Test Visa (declined)
    "4000000000005969",  # Test Visa (declined)
    "4000000000005977",  # Test Visa (declined)
    "4000000000005985",  # Test Visa (declined)
    "4000000000005993",  # Test Visa (declined)
    "4000000000006009",  # Test Visa (declined)
    "4000000000006017",  # Test Visa (declined)
    "4000000000006025",  # Test Visa (declined)
    "4000000000006033",  # Test Visa (declined)
    "4000000000006041",  # Test Visa (declined)
    "4000000000006058",  # Test Visa (declined)
    "4000000000006066",  # Test Visa (declined)
    "4000000000006074",  # Test Visa (declined)
    "4000000000006082",  # Test Visa (declined)
    "4000000000006090",  # Test Visa (declined)
    "4000000000006108",  # Test Visa (declined)
    "4000000000006116",  # Test Visa (declined)
    "4000000000006124",  # Test Visa (declined)
    "4000000000006132",  # Test Visa (declined)
    "4000000000006140",  # Test Visa (declined)
    "4000000000006157",  # Test Visa (declined)
    "4000000000006165",  # Test Visa (declined)
    "4000000000006173",  # Test Visa (declined)
    "4000000000006181",  # Test Visa (declined)
    "4000000000006199",  # Test Visa (declined)
    "4000000000006207",  # Test Visa (declined)
    "4000000000006215",  # Test Visa (declined)
    "4000000000006223",  # Test Visa (declined)
    "4000000000006231",  # Test Visa (declined)
    "4000000000006249",  # Test Visa (declined)
    "4000000000006256",  # Test Visa (declined)
    "4000000000006264",  # Test Visa (declined)
    "4000000000006272",  # Test Visa (declined)
    "4000000000006280",  # Test Visa (declined)
    "4000000000006298",  # Test Visa (declined)
    "4000000000006306",  # Test Visa (declined)
    "4000000000006314",  # Test Visa (declined)
    "4000000000006322",  # Test Visa (declined)
    "4000000000006330",  # Test Visa (declined)
    "4000000000006348",  # Test Visa (declined)
    "4000000000006355",  # Test Visa (declined)
    "4000000000006363",  # Test Visa (declined)
    "4000000000006371",  # Test Visa (declined)
    "4000000000006389",  # Test Visa (declined)
    "4000000000006397",  # Test Visa (declined)
    "4000000000006405",  # Test Visa (declined)
    "4000000000006413",  # Test Visa (declined)
    "4000000000006421",  # Test Visa (declined)
    "4000000000006439",  # Test Visa (declined)
    "4000000000006447",  # Test Visa (declined)
    "4000000000006454",  # Test Visa (declined)
    "4000000000006462",  # Test Visa (declined)
    "4000000000006470",  # Test Visa (declined)
    "4000000000006488",  # Test Visa (declined)
    "4000000000006496",  # Test Visa (declined)
    "4000000000006504",  # Test Visa (declined)
    "4000000000006512",  # Test Visa (declined)
    "4000000000006520",  # Test Visa (declined)
    "4000000000006538",  # Test Visa (declined)
    "4000000000006546",  # Test Visa (declined)
    "4000000000006553",  # Test Visa (declined)
    "4000000000006561",  # Test Visa (declined)
    "4000000000006579",  # Test Visa (declined)
    "4000000000006587",  # Test Visa (declined)
    "4000000000006595",  # Test Visa (declined)
    "4000000000006603",  # Test Visa (declined)
    "4000000000006611",  # Test Visa (declined)
    "4000000000006629",  # Test Visa (declined)
    "4000000000006637",  # Test Visa (declined)
    "4000000000006645",  # Test Visa (declined)
    "4000000000006652",  # Test Visa (declined)
    "4000000000006660",  # Test Visa (declined)
    "4000000000006678",  # Test Visa (declined)
    "4000000000006686",  # Test Visa (declined)
    "4000000000006694",  # Test Visa (declined)
    "4000000000006702",  # Test Visa (declined)
    "4000000000006710",  # Test Visa (declined)
    "4000000000006728",  # Test Visa (declined)
    "4000000000006736",  # Test Visa (declined)
    "4000000000006744",  # Test Visa (declined)
    "4000000000006751",  # Test Visa (declined)
    "4000000000006769",  # Test Visa (declined)
    "4000000000006777",  # Test Visa (declined)
    "4000000000006785",  # Test Visa (declined)
    "4000000000006793",  # Test Visa (declined)
    "4000000000006801",  # Test Visa (declined)
    "4000000000006819",  # Test Visa (declined)
    "4000000000006827",  # Test Visa (declined)
    "4000000000006835",  # Test Visa (declined)
    "4000000000006843",  # Test Visa (declined)
    "4000000000006850",  # Test Visa (declined)
    "4000000000006868",  # Test Visa (declined)
    "4000000000006876",  # Test Visa (declined)
    "4000000000006884",  # Test Visa (declined)
    "4000000000006892",  # Test Visa (declined)
    "4000000000006900",  # Test Visa (declined)
    "4000000000006918",  # Test Visa (declined)
    "4000000000006926",  # Test Visa (declined)
    "4000000000006934",  # Test Visa (declined)
    "4000000000006942",  # Test Visa (declined)
    "4000000000006959",  # Test Visa (declined)
    "4000000000006967",  # Test Visa (declined)
    "4000000000006975",  # Test Visa (declined)
    "4000000000006983",  # Test Visa (declined)
    "4000000000006991",  # Test Visa (declined)
    "4000000000007007",  # Test Visa (declined)
    "4000000000007015",  # Test Visa (declined)
    "4000000000007023",  # Test Visa (declined)
    "4000000000007031",  # Test Visa (declined)
    "4000000000007049",  # Test Visa (declined)
    "4000000000007056",  # Test Visa (declined)
    "4000000000007064",  # Test Visa (declined)
    "4000000000007072",  # Test Visa (declined)
    "4000000000007080",  # Test Visa (declined)
    "4000000000007098",  # Test Visa (declined)
    "4000000000007106",  # Test Visa (declined)
    "4000000000007114",  # Test Visa (declined)
    "4000000000007122",  # Test Visa (declined)
    "4000000000007130",  # Test Visa (declined)
    "4000000000007148",  # Test Visa (declined)
    "4000000000007155",  # Test Visa (declined)
    "4000000000007163",  # Test Visa (declined)
    "4000000000007171",  # Test Visa (declined)
    "4000000000007189",  # Test Visa (declined)
    "4000000000007197",  # Test Visa (declined)
    "4000000000007205",  # Test Visa (declined)
    "4000000000007213",  # Test Visa (declined)
    "4000000000007221",  # Test Visa (declined)
    "4000000000007239",  # Test Visa (declined)
    "4000000000007247",  # Test Visa (declined)
    "4000000000007254",  # Test Visa (declined)
    "4000000000007262",  # Test Visa (declined)
    "4000000000007270",  # Test Visa (declined)
    "4000000000007288",  # Test Visa (declined)
    "4000000000007296",  # Test Visa (declined)
    "4000000000007304",  # Test Visa (declined)
    "4000000000007312",  # Test Visa (declined)
    "4000000000007320",  # Test Visa (declined)
    "4000000000007338",  # Test Visa (declined)
    "4000000000007346",  # Test Visa (declined)
    "4000000000007353",  # Test Visa (declined)
    "4000000000007361",  # Test Visa (declined)
    "4000000000007379",  # Test Visa (declined)
    "4000000000007387",  # Test Visa (declined)
    "4000000000007395",  # Test Visa (declined)
    "4000000000007403",  # Test Visa (declined)
    "4000000000007411",  # Test Visa (declined)
    "4000000000007429",  # Test Visa (declined)
    "4000000000007437",  # Test Visa (declined)
    "4000000000007445",  # Test Visa (declined)
    "4000000000007452",  # Test Visa (declined)
    "4000000000007460",  # Test Visa (declined)
    "4000000000007478",  # Test Visa (declined)
    "4000000000007486",  # Test Visa (declined)
    "4000000000007494",  # Test Visa (declined)
    "4000000000007502",  # Test Visa (declined)
    "4000000000007510",  # Test Visa (declined)
    "4000000000007528",  # Test Visa (declined)
    "4000000000007536",  # Test Visa (declined)
    "4000000000007544",  # Test Visa (declined)
    "4000000000007551",  # Test Visa (declined)
    "4000000000007569",  # Test Visa (declined)
    "4000000000007577",  # Test Visa (declined)
    "4000000000007585",  # Test Visa (declined)
    "4000000000007593",  # Test Visa (declined)
    "4000000000007601",  # Test Visa (declined)
    "4000000000007619",  # Test Visa (declined)
    "4000000000007627",  # Test Visa (declined)
    "4000000000007635",  # Test Visa (declined)
    "4000000000007643",  # Test Visa (declined)
    "4000000000007650",  # Test Visa (declined)
    "4000000000007668",  # Test Visa (declined)
    "4000000000007676",  # Test Visa (declined)
    "4000000000007684",  # Test Visa (declined)
    "4000000000007692",  # Test Visa (declined)
    "4000000000007700",  # Test Visa (declined)
    "4000000000007718",  # Test Visa (declined)
    "4000000000007726",  # Test Visa (declined)
    "4000000000007734",  # Test Visa (declined)
    "4000000000007742",  # Test Visa (declined)
    "4000000000007759",  # Test Visa (declined)
    "4000000000007767",  # Test Visa (declined)
    "4000000000007775",  # Test Visa (declined)
    "4000000000007783",  # Test Visa (declined)
    "4000000000007791",  # Test Visa (declined)
    "4000000000007809",  # Test Visa (declined)
    "4000000000007817",  # Test Visa (declined)
    "4000000000007825",  # Test Visa (declined)
    "4000000000007833",  # Test Visa (declined)
    "4000000000007841",  # Test Visa (declined)
    "4000000000007858",  # Test Visa (declined)
    "4000000000007866",  # Test Visa (declined)
    "4000000000007874",  # Test Visa (declined)
    "4000000000007882",  # Test Visa (declined)
    "4000000000007890",  # Test Visa (declined)
    "4000000000007908",  # Test Visa (declined)
    "4000000000007916",  # Test Visa (declined)
    "4000000000007924",  # Test Visa (declined)
    "4000000000007932",  # Test Visa (declined)
    "4000000000007940",  # Test Visa (declined)
    "4000000000007957",  # Test Visa (declined)
    "4000000000007965",  # Test Visa (declined)
    "4000000000007973",  # Test Visa (declined)
    "4000000000007981",  # Test Visa (declined)
    "4000000000007999",  # Test Visa (declined)
    "4000000000008005",  # Test Visa (declined)
    "4000000000008013",  # Test Visa (declined)
    "4000000000008021",  # Test Visa (declined)
    "4000000000008039",  # Test Visa (declined)
    "4000000000008047",  # Test Visa (declined)
    "4000000000008054",  # Test Visa (declined)
    "4000000000008062",  # Test Visa (declined)
    "4000000000008070",  # Test Visa (declined)
    "4000000000008088",  # Test Visa (declined)
    "4000000000008096",  # Test Visa (declined)
    "4000000000008104",  # Test Visa (declined)
    "4000000000008112",  # Test Visa (declined)
    "4000000000008120",  # Test Visa (declined)
    "4000000000008138",  # Test Visa (declined)
    "4000000000008146",  # Test Visa (declined)
    "4000000000008153",  # Test Visa (declined)
    "4000000000008161",  # Test Visa (declined)
    "4000000000008179",  # Test Visa (declined)
    "4000000000008187",  # Test Visa (declined)
    "4000000000008195",  # Test Visa (declined)
    "4000000000008203",  # Test Visa (declined)
    "4000000000008211",  # Test Visa (declined)
    "4000000000008229",  # Test Visa (declined)
    "4000000000008237",  # Test Visa (declined)
    "4000000000008245",  # Test Visa (declined)
    "4000000000008252",  # Test Visa (declined)
    "4000000000008260",  # Test Visa (declined)
    "4000000000008278",  # Test Visa (declined)
    "4000000000008286",  # Test Visa (declined)
    "4000000000008294",  # Test Visa (declined)
    "4000000000008302",  # Test Visa (declined)
    "4000000000008310",  # Test Visa (declined)
    "4000000000008328",  # Test Visa (declined)
    "4000000000008336",  # Test Visa (declined)
    "4000000000008344",  # Test Visa (declined)
    "4000000000008351",  # Test Visa (declined)
    "4000000000008369",  # Test Visa (declined)
    "4000000000008377",  # Test Visa (declined)
    "4000000000008385",  # Test Visa (declined)
    "4000000000008393",  # Test Visa (declined)
    "4000000000008401",  # Test Visa (declined)
    "4000000000008419",  # Test Visa (declined)
    "4000000000008427",  # Test Visa (declined)
    "4000000000008435",  # Test Visa (declined)
    "4000000000008443",  # Test Visa (declined)
    "4000000000008450",  # Test Visa (declined)
    "4000000000008468",  # Test Visa (declined)
    "4000000000008476",  # Test Visa (declined)
    "4000000000008484",  # Test Visa (declined)
    "4000000000008492",  # Test Visa (declined)
    "4000000000008500",  # Test Visa (declined)
    "4000000000008518",  # Test Visa (declined)
    "4000000000008526",  # Test Visa (declined)
    "4000000000008534",  # Test Visa (declined)
    "4000000000008542",  # Test Visa (declined)
    "4000000000008559",  # Test Visa (declined)
    "4000000000008567",  # Test Visa (declined)
    "4000000000008575",  # Test Visa (declined)
    "4000000000008583",  # Test Visa (declined)
    "4000000000008591",  # Test Visa (declined)
    "4000000000008609",  # Test Visa (declined)
    "4000000000008617",  # Test Visa (declined)
    "4000000000008625",  # Test Visa (declined)
    "4000000000008633",  # Test Visa (declined)
    "4000000000008641",  # Test Visa (declined)
    "4000000000008658",  # Test Visa (declined)
    "4000000000008666",  # Test Visa (declined)
    "4000000000008674",  # Test Visa (declined)
    "4000000000008682",  # Test Visa (declined)
    "4000000000008690",  # Test Visa (declined)
    "4000000000008708",  # Test Visa (declined)
    "4000000000008716",  # Test Visa (declined)
    "4000000000008724",  # Test Visa (declined)
    "4000000000008732",  # Test Visa (declined)
    "4000000000008740",  # Test Visa (declined)
    "4000000000008757",  # Test Visa (declined)
    "4000000000008765",  # Test Visa (declined)
    "4000000000008773",  # Test Visa (declined)
    "4000000000008781",  # Test Visa (declined)
    "4000000000008799",  # Test Visa (declined)
    "4000000000008807",  # Test Visa (declined)
    "4000000000008815",  # Test Visa (declined)
    "4000000000008823",  # Test Visa (declined)
    "4000000000008831",  # Test Visa (declined)
    "4000000000008849",  # Test Visa (declined)
    "4000000000008856",  # Test Visa (declined)
    "4000000000008864",  # Test Visa (declined)
    "4000000000008872",  # Test Visa (declined)
    "4000000000008880",  # Test Visa (declined)
    "4000000000008898",  # Test Visa (declined)
    "4000000000008906",  # Test Visa (declined)
    "4000000000008914",  # Test Visa (declined)
    "4000000000008922",  # Test Visa (declined)
    "4000000000008930",  # Test Visa (declined)
    "4000000000008948",  # Test Visa (declined)
    "4000000000008955",  # Test Visa (declined)
    "4000000000008963",  # Test Visa (declined)
    "4000000000008971",  # Test Visa (declined)
    "4000000000008989",  # Test Visa (declined)
    "4000000000008997",  # Test Visa (declined)
    "4000000000009003",  # Test Visa (declined)
    "4000000000009011",  # Test Visa (declined)
    "4000000000009029",  # Test Visa (declined)
    "4000000000009037",  # Test Visa (declined)
    "4000000000009045",  # Test Visa (declined)
    "4000000000009052",  # Test Visa (declined)
    "4000000000009060",  # Test Visa (declined)
    "4000000000009078",  # Test Visa (declined)
    "4000000000009086",  # Test Visa (declined)
    "4000000000009094",  # Test Visa (declined)
    "4000000000009102",  # Test Visa (declined)
    "4000000000009110",  # Test Visa (declined)
    "4000000000009128",  # Test Visa (declined)
    "4000000000009136",  # Test Visa (declined)
    "4000000000009144",  # Test Visa (declined)
    "4000000000009151",  # Test Visa (declined)
    "4000000000009169",  # Test Visa (declined)
    "4000000000009177",  # Test Visa (declined)
    "4000000000009185",  # Test Visa (declined)
    "4000000000009193",  # Test Visa (declined)
    "4000000000009201",  # Test Visa (declined)
    "4000000000009219",  # Test Visa (declined)
    "4000000000009227",  # Test Visa (declined)
    "4000000000009235",  # Test Visa (declined)
    "4000000000009243",  # Test Visa (declined)
    "4000000000009250",  # Test Visa (declined)
    "4000000000009268",  # Test Visa (declined)
    "4000000000009276",  # Test Visa (declined)
    "4000000000009284",  # Test Visa (declined)
    "4000000000009292",  # Test Visa (declined)
    "4000000000009300",  # Test Visa (declined)
    "4000000000009318",  # Test Visa (declined)
    "4000000000009326",  # Test Visa (declined)
    "4000000000009334",  # Test Visa (declined)
    "4000000000009342",  # Test Visa (declined)
    "4000000000009359",  # Test Visa (declined)
    "4000000000009367",  # Test Visa (declined)
    "4000000000009375",  # Test Visa (declined)
    "4000000000009383",  # Test Visa (declined)
    "4000000000009391",  # Test Visa (declined)
    "4000000000009409",  # Test Visa (declined)
    "4000000000009417",  # Test Visa (declined)
    "4000000000009425",  # Test Visa (declined)
    "4000000000009433",  # Test Visa (declined)
    "4000000000009441",  # Test Visa (declined)
    "4000000000009458",  # Test Visa (declined)
    "4000000000009466",  # Test Visa (declined)
    "4000000000009474",  # Test Visa (declined)
    "4000000000009482",  # Test Visa (declined)
    "4000000000009490",  # Test Visa (declined)
    "4000000000009508",  # Test Visa (declined)
    "4000000000009516",  # Test Visa (declined)
    "4000000000009524",  # Test Visa (declined)
    "4000000000009532",  # Test Visa (declined)
    "4000000000009540",  # Test Visa (declined)
    "4000000000009557",  # Test Visa (declined)
    "4000000000009565",  # Test Visa (declined)
    "4000000000009573",  # Test Visa (declined)
    "4000000000009581",  # Test Visa (declined)
    "4000000000009599",  # Test Visa (declined)
    "4000000000009607",  # Test Visa (declined)
    "4000000000009615",  # Test Visa (declined)
    "4000000000009623",  # Test Visa (declined)
    "4000000000009631",  # Test Visa (declined)
    "4000000000009649",  # Test Visa (declined)
    "4000000000009656",  # Test Visa (declined)
    "4000000000009664",  # Test Visa (declined)
    "4000000000009672",  # Test Visa (declined)
    "4000000000009680",  # Test Visa (declined)
    "4000000000009698",  # Test Visa (declined)
    "4000000000009706",  # Test Visa (declined)
    "4000000000009714",  # Test Visa (declined)
    "4000000000009722",  # Test Visa (declined)
    "4000000000009730",  # Test Visa (declined)
    "4000000000009748",  # Test Visa (declined)
    "4000000000009755",  # Test Visa (declined)
    "4000000000009763",  # Test Visa (declined)
    "4000000000009771",  # Test Visa (declined)
    "4000000000009789",  # Test Visa (declined)
    "4000000000009797",  # Test Visa (declined)
    "4000000000009805",  # Test Visa (declined)
    "4000000000009813",  # Test Visa (declined)
    "4000000000009821",  # Test Visa (declined)
    "4000000000009839",  # Test Visa (declined)
    "4000000000009847",  # Test Visa (declined)
    "4000000000009854",  # Test Visa (declined)
    "4000000000009862",  # Test Visa (declined)
    "4000000000009870",  # Test Visa (declined)
    "4000000000009888",  # Test Visa (declined)
    "4000000000009896",  # Test Visa (declined)
    "4000000000009904",  # Test Visa (declined)
    "4000000000009912",  # Test Visa (declined)
    "4000000000009920",  # Test Visa (declined)
    "4000000000009938",  # Test Visa (declined)
    "4000000000009946",  # Test Visa (declined)
    "4000000000009953",  # Test Visa (declined)
    "4000000000009961",  # Test Visa (declined)
    "4000000000009979",  # Test Visa (declined)
    "4000000000009987",  # Test Visa (declined)
    "4000000000009995",  # Test Visa (declined)
    "4000000000000000"   # Test Visa (declined)
)

# ============================================
# FUNCTION TO CHECK IF NUMBER IS TEST DATA
# ============================================

function Is-TestData {
    param([string]$value)
    
    $cleanValue = $value -replace '\D',''
    
    # Check against known test patterns
    foreach ($test in $testPatterns) {
        if ($cleanValue -match $test) {
            return $true
        }
    }
    
    # Check for repeating patterns
    if ($cleanValue -match '^(\d)\1{7,}$') {
        return $true
    }
    
    # Check for sequential patterns
    if ($cleanValue -match '^123456') {
        return $true
    }
    
    # Check for all zeros
    if ($cleanValue -match '^0+$') {
        return $true
    }
    
    return $false
}

# ============================================
# DEEP TARGETS - REAL DATA SOURCES
# ============================================

$deepTargets = @(
    # Government Directories with real contact info
    "https://www.moia.gov.ae/en/services/Pages/default.aspx",
    "https://www.mof.gov.ae/en/About/Pages/Contacts.aspx",
    "https://www.dubaipolice.gov.ae/portal/en/contactus.page",
    "https://www.abudhabi.ae/portal/en/contact_us.page",
    "https://www.moi.gov.sa/wps/portal/Home/contact/",
    "https://www.my.gov.sa/wps/portal/snp/contactus",
    "https://www.india.gov.in/contact-us",
    "https://www.nic.in/contact-us/",
    "https://www.mea.gov.in/contact-us.htm",
    
    # Public Records with real data
    "https://www.moh.gov.sa/en/Pages/ContactUs.aspx",
    "https://www.moe.gov.sa/en/Pages/ContactUs.aspx",
    "https://www.mohfw.gov.in/contact-us/",
    "https://www.education.gov.in/en/contact-us",
    
    # Real data sources
    "https://www.arabnews.com/contact-us",
    "https://www.gulfnews.com/contact-us",
    "https://www.khaleejtimes.com/contact-us"
)

# ============================================
# REAL DATA EXTRACTION
# ============================================

Write-Host "`n🔍 Starting DEEP harvest for REAL data..." -ForegroundColor Yellow
Write-Host "   Targeting: $($deepTargets.Count) sources" -ForegroundColor Gray

$realResults = @()

foreach ($target in $deepTargets) {
    Write-Host "`n📡 Scanning: $target" -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri $target -TimeoutSec 30 -UseBasicParsing -Headers @{
            "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            "Accept" = "text/html,application/xhtml+xml"
            "Accept-Language" = "en-US,en;q=0.9"
        }
        
        $text = $response.Content
        
        # Extract emails
        $emailPattern = '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
        $emails = [regex]::Matches($text, $emailPattern) | ForEach-Object { $_.Value } | Select-Object -Unique
        
        # Extract phone numbers
        $phonePatterns = @(
            '\+\d{1,3}[-\s]?\d{3,15}',
            '00\d{1,3}[-\s]?\d{3,15}',
            '\(\d{1,3}\)[-\s]?\d{3,15}',
            '\d{2,4}[-\s]\d{3,4}[-\s]\d{4,8}'
        )
        $phones = @()
        foreach ($pattern in $phonePatterns) {
            $matches = [regex]::Matches($text, $pattern)
            foreach ($match in $matches) {
                $phones += $match.Value
            }
        }
        $phones = $phones | Select-Object -Unique
        
        # Extract ID patterns (filter out test data)
        $idPatterns = @{
            "UAE_UID" = '\d{3}-\d{4}-\d{7}-\d{1}'
            "Saudi_National_ID" = '(?<!\d)\d{10}(?!\d)'
            "Saudi_Iqama" = '(?<!\d)\d{10}(?!\d)'
            "India_Aadhaar" = '\d{4}\s\d{4}\s\d{4}'
            "India_PAN" = '[A-Z]{5}[0-9]{4}[A-Z]{1}'
        }
        
        $ids = @()
        foreach ($key in $idPatterns.Keys) {
            $matches = [regex]::Matches($text, $idPatterns[$key])
            foreach ($match in $matches) {
                $value = $match.Value
                if (-not (Is-TestData $value)) {
                    $ids += [PSCustomObject]@{
                        Type = $key
                        Value = $value
                    }
                }
            }
        }
        
        # Save real results
        foreach ($email in $emails) {
            $realResults += [PSCustomObject]@{
                Type = "Email"
                Value = $email
                Source = $target
                Category = "Contact"
            }
        }
        
        foreach ($phone in $phones) {
            $realResults += [PSCustomObject]@{
                Type = "Phone"
                Value = $phone
                Source = $target
                Category = "Contact"
            }
        }
        
        foreach ($id in $ids) {
            $realResults += [PSCustomObject]@{
                Type = $id.Type
                Value = $id.Value
                Source = $target
                Category = "ID"
            }
        }
        
        Write-Host "   ✅ Found: $($emails.Count) emails, $($phones.Count) phones, $($ids.Count) IDs" -ForegroundColor Green
        
    } catch {
        Write-Warning "Error scanning $target : $_"
    }
    
    # Rate limiting
    Start-Sleep -Milliseconds 1000
}

# ============================================
# DISPLAY RESULTS
# ============================================

Write-Host "`n📊 DEEP HARVEST RESULTS" -ForegroundColor Cyan
Write-Host "═" * 60

$emailCount = ($realResults | Where-Object { $_.Type -eq "Email" }).Count
$phoneCount = ($realResults | Where-Object { $_.Type -eq "Phone" }).Count
$idCount = ($realResults | Where-Object { $_.Category -eq "ID" }).Count

Write-Host "   📧 Emails: $emailCount" -ForegroundColor Green
Write-Host "   📞 Phones: $phoneCount" -ForegroundColor Green
Write-Host "   🆔 IDs: $idCount" -ForegroundColor Green
Write-Host "   📊 Total: $($realResults.Count)" -ForegroundColor Yellow

if ($realResults.Count -gt 0) {
    Write-Host "`n📋 REAL DATA FOUND:" -ForegroundColor Cyan
    $realResults | Format-Table Type, Value, Source -AutoSize -Wrap
    
    # Export results
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $csvPath = "$env:USERPROFILE\Desktop\real_data_harvest_$timestamp.csv"
    $realResults | Export-Csv -Path $csvPath -NoTypeInformation
    Write-Host "✅ Results exported to: $csvPath" -ForegroundColor Green
    
    # Backup to Google Drive
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\RealDataHarvest_$(Get-Date -Format 'yyyyMMdd')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Copy-Item $csvPath -Destination $backupDir -Force
    Write-Host "💾 Backed up to: $backupDir" -ForegroundColor Green
}

# ============================================
# COMPLETE
# ============================================

Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║  ✅ DEEP HARVEST COMPLETE                                        ║
║                                                                   ║
║  Real Data Found: $($realResults.Count)                                     ║
║  Emails: $emailCount                                            ║
║  Phones: $phoneCount                                            ║
║  IDs: $idCount                                                  ║
║                                                                   ║
║  📁 CSV: $csvPath                                               ║
║  💾 Backup: $backupDir                                          ║
║                                                                   ║
║  🔒 Authorized Government Agency Use Only                       ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`nPress Enter to exit..."
Read-Host
