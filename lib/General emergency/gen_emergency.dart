import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:realheros_durga/Drawer/Side_Drawer.dart';

class General_emer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'General Emergencies',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      // ignore: missing_required_param
      drawer: AppDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFB71C1C),
                      Color(0xFFD50000),
                      Color(0xFFC62828),
                      Color(0xFFE65100),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 40.0,
                  //   vertical: 120.0,
                  // ),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(height: 10.0),
                      //_titleSection(),
                      _covidSection(),
                      _medicalSection(),
                      _roadSection(),
                      _mentalSection(),
                      _mealSection(),
                      _missingSection(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleSection() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  SizedBox(height: 10.0),
          Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Center(
                        child: Text(
                          'GENERAL EMERGENCIES',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                            decoration: TextDecoration.underline,
                            // decorationColor: Colors.red[900]),
                          ),
                        ),
                      ),
                    ],
                  )))
        ]);
  }

  Widget _covidSection() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'COVID RELIEF',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      Text(
                        'Request oxygen/ beds/ ambulance',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'The second wave of COVID – 19 is raging across India with devastating impact. With more than 3.8 million active cases as of May 7, 2021, there is a dire need for hospital beds, doctors, medical equipment and consumables, and greater awareness around COVID appropriate behaviour in communities.',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: _launchURL1,
                              child: new Text(
                                'Website',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: () => launch("tel://08046848600"),
                              child: new Text(
                                'Call',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  )))
        ]);
  }

  Widget _medicalSection() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'MEDICAL EMERGENCY',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      Text(
                        'Request Medical attention',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'The second wave of COVID – 19 is raging across India with devastating impact. With more than 3.8 million active cases as of May 7, 2021, there is a dire need for hospital beds, doctors, medical equipment and consumables, and greater awareness around COVID appropriate behaviour in communities.',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: _launchURL2,
                              child: new Text(
                                'Website',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              // 9745697456
                              onPressed: () => launch("tel://9745697456"),
                              child: new Text(
                                'Call',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  )))
        ]);
  }

  Widget _roadSection() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'ROADSIDE ASSISTANCE',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      Text(
                        'ReadyAssist 24/7 assistance',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'We provide 24 hours on the spot breakdown repair services for all kind of problems related to battery, electrical, cables replacement, fuses etc. Other services offered include emergency fuel, tyre puncture, Locked cars and towing services',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: _launchURL3,
                              child: new Text(
                                'Website',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: () => launch("tel://8197852852"),
                              child: new Text(
                                'Call',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  )))
        ]);
  }

  Widget _mentalSection() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Mental Health',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      Text(
                        'Available all days - 5 pm to 8 pm',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Samaritans Mumbai is a helpline providing emotional support for those who are stressed, distressed, depressed, or suicidal. If anything is bothering you, you can call us any day between 5 pm to 8 pm on +91 84229 84528 / +91 84229 84529 / +91 84229 84530 or email us at talk2samaritans@gmail.com . We guarantee complete anonymity and confidentiality between you and Samaritans.',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: _launchURL6,
                              child: new Text(
                                'Website',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: () => launch("tel://8422984528"),
                              child: new Text(
                                'Call',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  )))
        ]);
  }

  Widget _mealSection() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'REQUEST A MEAL',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'All our initiatives are designed to provide essential food support to underserved communities in the form of raw grains, freshly cooked food or packaged food products depending on the need. Our aim is to ensure, hunger never comes in the way of a brighter future.',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: _launchURL4,
                              child: new Text(
                                'Website',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: () => launch("tel://1967"),
                              child: new Text(
                                'Call',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  )))
        ]);
  }

  //NATIONAL TRACKING SYSTEM for MISSING & VULNERABLE CHILDREN
  Widget _missingSection() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10.0),
          Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'REPORT MISSING CHILDREN',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      // Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                      Text(
                        'NATIONAL TRACKING SYSTEM',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.red[900]),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'The Ministry of Women and Child Development is implementing a Centrally Sponsored Scheme, namely the Integrated Child Protection Scheme (ICPS). The objectives of the scheme are to contribute to the improvement in the well being of children in difficult circumstances, as well as to the reduction of vulnerabilities to situations and actions that lead to abuse, neglect, exploitation, abandonment and separation of children.',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: _launchURL5,
                              child: new Text(
                                'Website',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.amber)),
                              onPressed: () => launch("tel://1098"),
                              child: new Text(
                                'Call',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                    ],
                  )))
        ]);
  }

  _launchURL1() async {
    const url = 'https://covid19.karnataka.gov.in/page/Helpline/en';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL2() async {
    const url = 'https://www.covidsos.live/app/index.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL3() async {
    const url = 'https://www.readyassist.in/readyassist-services.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL4() async {
    const url =
        'https://blrforhumanity.com/dl/ewAiAHQAIgA6ADAALAAiAHMAIgA6ACIAbQBlAG4AdQAtAGMAMQAyADcAMwA1ADYAOQAtADgANgAyADgALQA0ADEAZgBlAC0AYQA3ADEAOQAtADkAYQBkADAAZgAyAGUANQA3AGIAYgAwAC0AZgBjADIANwA2ADYAMgAyADIAYwBmAGUAOQBkAGYAOABmADYAMgA0ADYANQBlADEAYwBiAGQAYQBiADMAMQBhACIALAAiAHIAIgA6ACIAaAB3AFgANgA1AGoAVABUAFMAegBHAGEAQwBtAHgAMwA0AHIAVABCAHAAQQAiAH0A';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL5() async {
    const url = 'https://trackthemissingchild.gov.in/trackchild/index.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

_launchURL6() async {
  const url = 'http://samaritansmumbai.org/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
