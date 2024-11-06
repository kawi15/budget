import 'package:flutter/material.dart';


class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key, required this.month}) : super(key: key);

  final DateTime month;

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> with TickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TooltipVisibility(
      visible: false,
      child: Scaffold(
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: const [
                  Tab(
                      child: Text(
                        'Wydatki',
                        style: TextStyle(
                            color: Colors.black
                        ),
                      )
                  ),
                  Tab(
                    child: Text(
                      'Przychody',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ListView.builder(
                      itemCount: 10,
                      itemBuilder: (ctx, index) {
                        return Card(
                          //color: Colors.greenAccent,
                          child: SizedBox(
                            height: 100,
                            //width: 200,
                            child: Center(
                              child: ListTile(
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey
                                  ),
                                  child: Center(child: const Text('-10zł')),
                                ),
                                title: Text('Nazwa transakcji'),
                                subtitle: Text('Data transakcji'),
                                trailing: PopupMenuButton(
                                  tooltip: null,
                                  splashRadius: 1,
                                  itemBuilder: (ctx) {
                                    return <PopupMenuEntry>[
                                      PopupMenuItem(
                                        onTap: () {

                                        },
                                        child: Text('Edytuj')
                                      ),
                                      PopupMenuItem(
                                        onTap: () {

                                        },
                                        child: Text('Usuń')
                                      ),
                                    ];
                                  },
                                ),
                                style: ListTileStyle.drawer,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: 10,
                      itemBuilder: (ctx, index) {
                        return Card(

                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
