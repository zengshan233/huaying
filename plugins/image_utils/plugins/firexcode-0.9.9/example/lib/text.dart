import 'package:flutter/material.dart';
import 'package:firexcode/firexcode.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage().xMaterialApp(title: 'zeeshan');
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: 'Material X Gradients Card '.xTextColorBlack(),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: <Widget>[
            XCardTile(
              backgroundColor: Colors.deepOrangeAccent.shade400,
              boxColor: Colors.deepOrangeAccent.shade100,
              subtitle1: Icons.arrow_forward_ios.xIconTile(),
            ).animation(configMap: XAnimationType.fadeIn, autoPlay: true),
            XCardTile(
              rounded: 10,
              title: 'Zeeshan'.xCardTileTitle(),
              subtitle1: 'Software Engineer'.xTextColorWhite(),
              backgroundColor: Colors.deepPurple,
              boxColor: Colors.deepPurple.shade100,
              boxRounded: 100,
              boxChild: Icons.android.xIconTile(),
              subtitle2: Icons.data_usage.xIconTile().bounce(),
            ).fadeIn(),
            20.0.sizedHeight(),

            ListTile(
              onTap: () {
                //  XRoutePage(context, Drawer()).materialPagePush();
              },
              leading: Icons.book.xListTileIcon(color: Colors.purple),
              title: 'Zeeshan'.xCardTileTitle(color: Colors.black),
              subtitle: 'Developr!!'.xTextColorGrey(),
              trailing: <Widget>[
                '+ 1234500.0'
                    .xTextColorBlack(fontsize: 15, fontWeight: FontWeight.bold),
                5.0.sizedHeight(),
                'sep 15 2019'.xTextColorBlueGrey()
              ].xcolumnCC(),
            ),

            HeaderTitle(
              title: 'Flight'
                  .xTextColorBlack(fontsize: 30, fontWeight: FontWeight.bold),
              subtitle: 'June 18, Thu 04:50'.xTextColorGrey(),
            ),
            XContainer(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(20.0),
                rounded: 5,
                // height: 100,
                color: Colors.indigo,
                child: <Widget>[
                  <Widget>[
                    Icons.arrow_back_ios.xIconTile(),
                    'Monday 27 july 2000'.xTextColorWhite(),
                    Icons.arrow_forward_ios.xIconTile(),
                  ].xRowCSB(),
                  25.0.sizedHeight(),
                  H2(
                    text: '7h 26Min',
                    color: Colors.white,
                  ),
                  20.0.sizedHeight(),
                ].xcolumn()),
            Column(
              children: <Widget>[
                CardBarButton(
                  onTap: () {},
                  color: Colors.black,
                  title: Icons.android.xIconTile(color: Colors.white, size: 30),
                  subtitle: 'Zeeshan'.xTextColorWhite(),
                )
              ],
            ),
            XContainer(
                color: Colors.blue,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 100,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            XCardBanner(
                    onTap: () {},
                    margin: EdgeInsets.all(20),
                    rounded: 10,
                    color: Color(0xFF3d6dfe),
                    shadowColor: Colors.blue,
                    blurRadius: 5.0,
                    title: 'Bonus'.xH2Text(),
                    subTitle:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
                            .xText(),
                    button: 'know more'.xTextColorWhite().cardBannerButton(
                        onTap: () {}, buttonColor: Colors.lime))
                .animation(
                    autoPlay: true,
                    configMap: XAnimationType.fadeIn,
                    // delay: Duration(seconds: 10),
                    duration: Duration(seconds: 3)),
            XGradientCardBanner(
                gradient: [Color(0xFF3C8CE7), Color(0xFF3C8CE7)].xLGrepeated(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 0.0),
                ),
                shadowColor: Colors.blue,
                blurRadius: 5.0,
                title: 'Bonus'.xH2Text(),
                subTitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
                        .xTextColorWhite(),
                button: 'know more'
                    .xTextColorWhite()
                    .cardBannerButton(onTap: () {})),
            SizedBox(
              height: 10.0,
            ),
            XGradientCardBanner(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8,
                          0.0), // 10% of the width, so there are ten blinds.
                      colors: [Colors.red, Colors.amber], // whitish to gray
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                    shadowColor: Colors.blue,
                    blurRadius: 5.0,
                    title: 'Bonus'.xH2Text(),
                    subTitle:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
                            .xTextColorWhite(),
                    button: 'know more'
                        .xTextColorWhite()
                        .cardBannerButton(onTap: () {}))
                .animation(configMap: XAnimationType.fadeIn, autoPlay: true),
            SizedBox(
              height: 10.0,
            ),
            XGradientCardBanner(
                    onTap: () {},
                    spreadRadius: 0.2,
                    rightSideChild: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Icon(
                        Icons.ac_unit,
                        size: 30,
                      ),
                    ),
                    rounded: 10,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0.8,
                          0.0), // 10% of the width, so there are ten blinds.
                      colors: [
                        Colors.deepPurple,
                        Colors.purple,
                      ], // whitish to gray
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                    shadowColor: Colors.blue,
                    blurRadius: 5.0,
                    title: 'Bonus'.xH2Text(),
                    subTitle:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore'
                            .xTextColorWhite(),
                    button: 'know more'
                        .xTextColorWhite()
                        .cardBannerButton(onTap: () {}))
                .animation(configMap: XAnimationType.fadeIn, autoPlay: true),
            //Textmaterial(text: 'null'),
            <Widget>[Icon(Icons.ac_unit).bounce()].xRowCSB(),
            <Widget>[
              H1(
                text: 'aaaaa',
              ),
              XContainer(
                      onTap: () {
                        XRoutePage(context, Drawer()).fadePush();
                      },
                      height: 100,
                      color: Colors.pink,
                      child: Textmaterial(text: 'text'))
                  .roulette()
            ].xcolumnCC(),
            30.0.sizedHeight(),
            CardTile(
              margin: EdgeInsets.all(10),
              onTap: () {},
              title: H2(
                text: 'Zeeshan',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              subtitle:
                  ''' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'''
                      .xTextColorBlack(),
            ),
            30.0.sizedHeight(),
            XContainerGradient(
                rounded: 5,
                blurRadius: 15,
                offset: Offset(0, 8),
                spreadRadius: 0.5,
                shadowColor: Colors.black,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(
                      0.8, 0.0), // 10% of the width, so there are ten blinds.
                  colors: [Colors.red, Colors.pink], // whitish to gray
                  tileMode:
                      TileMode.mirror, // repeats the gradient over the canvas
                ),
                child: <Widget>[
                  25.0.sizedHeight(),
                  'https://pixinvent.com/materialize-material-design-admin-template/app-assets/images/icon/apple-watch.png'
                      .xCircleNetWorkImage(
                          radius: 40, backgroundColor: Colors.white),
                  25.0.sizedHeight(),
                  '50% Off'.xH1Text(fontWeight: FontWeight.normal),
                  10.0.sizedHeight(),
                  'On apple watch'.xH3Text(fontWeight: FontWeight.normal),
                  25.0.sizedHeight(),
                ].xcolumnCC()),
            25.0.sizedHeight(),
            XContainer(
              padding: EdgeInsets.all(0.0),
              child: <Widget>[
                XHeader(
                  onTap: () {},
                  child: <Widget>[
                    HeaderTitle(
                      title: 'Flight'.xTextColorBlack(
                          fontsize: 30, fontWeight: FontWeight.bold),
                      subtitle: 'June 18, Thu 04:50'.xTextColorBlack(),
                    ),
                  ].xcolumnSC(),
                ),
                XContainer(
                  height: 400,
                  padding: EdgeInsets.all(0.0),
                  image:
                      'https://pixinvent.com/materialize-material-design-admin-template/app-assets/images/gallery/3.png'
                          .decorationINToCover(),
                  child: XimageBlur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                )
              ].xListViewVerticalClampingScrollPhysics(
                  padding: EdgeInsets.all(0.0)),
            ).fadeInLeft(),
            25.0.sizedHeight(),
            [
              Container(
                height: 100,
                alignment: Alignment(0, 0),
                color: Colors.purple,
                child: Text('lg : 12'),
              ).xResponsiveGridCol(),
              Container(
                height: 100,
                alignment: Alignment(0, 0),
                color: Colors.purple,
                child: Text('lg : 6'),
              ).fadeIn().xResponsiveGridCol(lg: 6, md: 6, sm: 6, xs: 6),
            ].xResponsiveGridRow()
          ].xListView()),
      floatingActionButton: 'check'.xFloationActionButton(onTap: () {
        var isDesktops = context.isDesktop();
        print(isDesktops);
        var isTablets = context.isTablet();
        print(isTablets);
        var isMobiles = context.isMobile();
        print(isMobiles);
      }),
    );
  }
}

class Square extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
    );
  }
}
