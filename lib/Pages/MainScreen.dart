import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:report_app/Pages/EventDetailPage.dart';
import 'package:report_app/Services/events.dart';
import 'package:report_app/Widgets/CupertinoListTile.dart';
import '../Services/zones.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'dart:ui';

import 'package:report_app/Models/MapEvent.dart';
import 'package:report_app/Models/MapZone.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final eventsService = EventsService();
  final zonesService = ZonesService();
  final searchController = TextEditingController();
  bool showZones = true;
  bool showEvents = true;
  bool showDateFilter = true;
  bool typeOfMap = true;
  DateTimeRange filterDateRange = DateTimeRange(
    start: DateTime(2022, 1, 1),
    end: DateTime(2022, 12, 31),
  );

  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  late List<MapEvent> _mapEvents;
  late List<MapEvent> _filteredEvents;
  late List<MapZone> _mapZones;

  late int _currentSelectedIndex;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;

  late double _cardHeight;

  late bool _canUpdateFocalLatLng;

  Color getZoneColor(MapZone zone) {
    int cantEvents = zone.events.length;
    return zone.color.withAlpha(((cantEvents * ((255 - 50) / 3)) + 50).toInt());
  }

  double getZoneRadius(MapZone zone) {
    int cantEvents = zone.events.length;
    return ((cantEvents * ((50 - 10) / 10)) + 10);
  }

  String getFormattedDate(DateTime date) {
    String month = '';

    switch (date.month) {
      case 1:
        month = 'Ene';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Abr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Ago';
        break;
      case 9:
        month = 'Sep';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dic';
        break;
    }

    return '${date.day} $month ${date.year} ';
  }

  Future fetchEvents() async {
    final events = await eventsService.getEvents();
    for (final event in events['data']) {
      _mapEvents.add(MapEvent(
          date: event['date'],
          status: event['status'],
          time: event['time'],
          type: event['type'],
          userId: event['userId'],
          zoneCode: event['zoneCode'],
          latitude: event['location'][0],
          longitude: event['location'][1],
          description: event['eventDescription'],
          comment: event['comment']));
    }
  }

  Future fetchZones() async {
    final zones = await zonesService.getZones();

    for (final zone in zones['data']) {
      _mapZones.add(MapZone(
        code: zone['zoneCode'],
        center: MapLatLng(zone['location'][0], zone['location'][1]),
        color: Colors.red.shade300,
        events: zone['idEvents'],
        posts: zone['idPosts'],
        radius: 10,
      ));
    }
  }

  void loadFilteredEvents() {
    _mapController.clearMarkers();
    _filteredEvents.clear();

    print("Switching");

    if (showEvents) {
      int markersCount = 0;

      for (MapEvent mapEvent in _mapEvents) {
        final eventDate = DateTime.parse('${mapEvent.date} ${mapEvent.time}');

        if (eventDate.isAfter(filterDateRange.start) &&
            eventDate.isBefore(filterDateRange.end)) {
          _filteredEvents.add(mapEvent);
          _mapController.insertMarker(markersCount);
          markersCount++;
        }
      }
    } else {
      print("disabled");
    }

    setState(() {});
  }

  void _handlePageChange(int index) {
    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
          _filteredEvents[_currentSelectedIndex].latitude,
          _filteredEvents[_currentSelectedIndex].longitude);
    }

    /// Updating the design of the selected marker. Please check the
    /// `markerBuilder` section in the build method to know how this is done.
    _mapController
        .updateMarkers(<int>[_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = 0;
    _canUpdateFocalLatLng = true;
    _mapController = MapTileLayerController();
    _mapEvents = <MapEvent>[];
    _filteredEvents = <MapEvent>[];
    _mapZones = <MapZone>[];

    Future.delayed(const Duration(seconds: 0), () async {
      await fetchEvents();
      await fetchZones();
      loadFilteredEvents();
    });

    _zoomPanBehavior = MapZoomPanBehavior(
        zoomLevel: 12,
        minZoomLevel: 3,
        maxZoomLevel: 15,
        focalLatLng: const MapLatLng(6.217, -75.567),
        enableDoubleTapZooming: true,
        toolbarSettings: const MapToolbarSettings(direction: Axis.vertical));

    _cardHeight = 120;

    _pageViewController = PageController(
        initialPage: _currentSelectedIndex, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    _mapEvents.clear();
    _filteredEvents.clear();
    super.dispose();
  }

  Widget mapFilters() {
    final filterStartDate = filterDateRange.start;
    final filterEndDate = filterDateRange.end;

    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.all(8),
            child: PhysicalModel(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              elevation: 4,
              shadowColor: Color(0x55000000),
              child: TextField(
                controller: searchController,
                autocorrect: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  filled: true, //<-- SEE HERE
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  prefixIcon: const Icon(CupertinoIcons.search),
                  suffixIcon: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      filtersDialog(context);
                    },
                    child: Icon(Icons.more_vert_rounded),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                ),
              ),
            )),
        showDateFilter
            ? Container(
                width: MediaQuery.of(context).size.width / 1.75,
                margin: EdgeInsets.only(top: 60, left: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: PhysicalModel(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Color(0x55000000),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(100),
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    onPressed: () {
                      pickDateRange();
                    },
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.calendar_today,
                            color: CupertinoColors.secondaryLabel,
                            size: 18,
                          ),
                          Expanded(
                            child: Text(
                              getFormattedDate(filterStartDate),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.secondaryLabel),
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(
                            child: Text(
                              getFormattedDate(filterEndDate),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.secondaryLabel),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
            : const SizedBox(),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 128),
            child: PhysicalModel(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              elevation: 4,
              shadowColor: const Color(0x99000000),
              child: Tooltip(
                message: "Map style",
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 40,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const Icon(
                    CupertinoIcons.map,
                    size: 16,
                    color: CupertinoColors.secondaryLabel,
                  ),
                  onPressed: () {
                    setState(() {
                      typeOfMap = !typeOfMap;
                    });
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget mapEvents() {
    return Flexible(
      child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Stack(
            children: <Widget>[
              SfMaps(
                layers: <MapLayer>[
                  MapTileLayer(
                    urlTemplate: typeOfMap
                        ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                        : 'https://b.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                    zoomPanBehavior: _zoomPanBehavior,
                    controller: _mapController,
                    initialMarkersCount: _filteredEvents.length,
                    tooltipSettings: const MapTooltipSettings(
                      color: Colors.transparent,
                    ),
                    markerTooltipBuilder: (BuildContext context, int index) {
                      return ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5.0, bottom: 5.0),
                                width: 150,
                                color: Colors.white,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _filteredEvents[index].description,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          _filteredEvents[index].comment,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      )
                                    ]),
                              ),
                            ]),
                      );
                    },
                    markerBuilder: (BuildContext context, int index) {
                      final double markerSize =
                          _currentSelectedIndex == index ? 40 : 25;
                      return MapMarker(
                        latitude: _filteredEvents[index].latitude,
                        longitude: _filteredEvents[index].longitude,
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            final progress = ProgressHUD.of(context);
                            progress!.show();

                            if (_currentSelectedIndex != index) {
                              _canUpdateFocalLatLng = false;
                              _tappedMarkerIndex = index;
                              _pageViewController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }

                            Future.delayed(const Duration(seconds: 1), () {
                              progress.dismiss();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailPage(
                                      eventData: _filteredEvents[index]),
                                ),
                              );
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: markerSize,
                            width: markerSize,
                            child: FittedBox(
                              child: Icon(Icons.location_on,
                                  color: _currentSelectedIndex == index
                                      ? Colors.blue
                                      : Colors.red,
                                  size: markerSize),
                            ),
                          ),
                        ),
                      );
                    },
                    sublayers: showZones
                        ? [
                            MapCircleLayer(
                              circles: List<MapCircle>.generate(
                                _mapZones.length,
                                (int index) {
                                  return MapCircle(
                                    center: _mapZones[index].center,
                                    radius: getZoneRadius(_mapZones[index]),
                                    color: getZoneColor(_mapZones[index]),
                                    strokeColor: _mapZones[index].color,
                                  );
                                },
                              ).toSet(),
                            ),
                          ]
                        : [],
                  ),
                ],
              ),
              mapFilters(),
              showEvents
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: _cardHeight,
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PageView.builder(
                          itemCount: _filteredEvents.length,
                          onPageChanged: _handlePageChange,
                          controller: _pageViewController,
                          itemBuilder: (BuildContext context, int index) {
                            final MapEvent item = _filteredEvents[index];
                            return Transform.scale(
                              scale: index == _currentSelectedIndex ? 1 : 0.85,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(190),
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 0,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                            offset: Offset.zero)
                                      ],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(children: <Widget>[
                                      // Adding title and description for card.
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(_filteredEvents[index].comment,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                              textAlign: TextAlign.start),
                                          const SizedBox(height: 4),
                                          Expanded(
                                              child: Text(
                                            item.description,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )),
                                        ],
                                      )),
                                      // Adding Image for card.
                                    ]),
                                  ),
                                  // Adding splash to card while tapping.
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                          Radius.elliptical(8, 8)),
                                      onTap: () {
                                        if (_currentSelectedIndex != index) {
                                          _pageViewController.animateToPage(
                                            index,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        } else {
                                          final progress =
                                              ProgressHUD.of(context);
                                          progress!.show();

                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            progress.dismiss();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EventDetailPage(
                                                        eventData:
                                                            _filteredEvents[
                                                                index]),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          )),
    );
  }

  void filtersDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return CupertinoAlertDialog(
          title: const Text('Filtros adicionales'),
          content: Container(
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                CupertinoListTile(
                  text: "Zonas calientes",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showZones = !showZones;
                    });
                    setState(() {});
                  },
                  child: CupertinoSwitch(
                    value: showZones,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showZones = value!;
                      });
                      setState(() {});
                    },
                  ),
                ),
                CupertinoListTile(
                  text: "Eventos",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showEvents = !showEvents;
                    });
                    loadFilteredEvents();
                  },
                  child: CupertinoSwitch(
                    value: showEvents,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showEvents = value!;
                      });
                      loadFilteredEvents();
                    },
                  ),
                ),
                CupertinoListTile(
                  text: "Filtro de fecha",
                  color: Colors.transparent,
                  onPressed: () {
                    setModalState(() {
                      showDateFilter = !showDateFilter;
                    });
                    setState(() {});
                  },
                  child: CupertinoSwitch(
                    value: showDateFilter,
                    thumbColor: CupertinoColors.white,
                    trackColor: CupertinoColors.extraLightBackgroundGray,
                    onChanged: (bool? value) {
                      setModalState(() {
                        showDateFilter = !showDateFilter;
                      });
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Atrás',
                style: TextStyle(color: CupertinoColors.link),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: filterDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (newDateRange == null) return;

    setState(() {
      filterDateRange = newDateRange;
      loadFilteredEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        backgroundRadius: const Radius.circular(100),
        barrierColor: Colors.black26,
        borderColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 16),
          child: Column(
            children: [mapEvents()],
          ),
        ),
      ),
    );
  }
}
