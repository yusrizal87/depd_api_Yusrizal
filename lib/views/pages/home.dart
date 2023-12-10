// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty

part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic provinceData;
  dynamic cityorigindata;
  dynamic citydestinationdata;
  bool isLoading = true;
  dynamic kurir;
  TextEditingController berat = TextEditingController();
  dynamic kotaorigin;
  dynamic kotadestinasi;
  dynamic proforigin;
  dynamic profdestinasi;

  Future<List<Province>> getProvinces() async {
    dynamic temp;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        temp = value;
        isLoading = false;
      });
    });
    return temp;
  }

  Future<List<City>> getCity(var profid) async {
    dynamic temp;
    await MasterDataService.getCity(profid).then((value) {
      setState(() {
        temp = value;
      });
    });
    return temp;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: DropdownButton(
                            isExpanded: true,
                            value: kurir,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 4,
                            hint: Text("jasa pengiriman"),
                            items: [
                              DropdownMenuItem(
                                value: "jne",
                                child: Text("JNE"),
                              ),
                              DropdownMenuItem(
                                value: "tiki",
                                child: Text("TIKI"),
                              ),
                              DropdownMenuItem(
                                value: "pos",
                                child: Text("POS"),
                              ),
                            ],
                            onChanged: (newValue) {
                              setState(() {
                                kurir = newValue;
                              });
                            },
                          )),
                          Expanded(
                              child: TextField(
                            controller: berat,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(label: Text("berat")),
                          ))
                        ],
                      ),
                      Row(
                        children: [Expanded(child: Text("origin"))],
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: FutureBuilder<List<Province>>(
                            future: provinceData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton(
                                  value: proforigin,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  elevation: 4,
                                  style: TextStyle(color: Colors.grey),
                                  hint: proforigin == null
                                      ? Text('pilih provinsi')
                                      : Text(proforigin.province),
                                  items: snapshot.data!
                                      .map<DropdownMenuItem<Province>>(
                                          (Province value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.province.toString()));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      proforigin = newValue;
                                      cityorigindata =
                                          getCity(proforigin.provinceId);
                                    });
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text("data");
                              }
                              return UiLoading.loadingBlock();
                            },
                          ))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: provinceData!.length == 0
                      ? const Align(
                          alignment: Alignment.center,
                          child: Text("Data tidak ditemukan"),
                        )
                      : ListView.builder(
                          itemBuilder: (content, index) {
                            return CardProvince(provinceData![index]);
                          },
                          itemCount: provinceData?.length,
                        ),
                ),
              ],
            ),
          if (isLoading) UiLoading.loadingBlock(),
        ],
      ),
    );
  }
}
