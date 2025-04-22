import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:jfbfestival/main.dart'; // Assuming MainScreen is here
// *** USE the definitions AND the service from timetableData.dart ***
import 'package:jfbfestival/data/timetableData.dart';
// *** REMOVE SupabaseService import if not used elsewhere ***
// import 'package:jfbfestival/services/supabase_service.dart';
import 'package:jfbfestival/settings_page.dart';
import 'package:collection/collection.dart';

// Helper class - Keep as is
class CurrentAndUpcomingEvents {
  final List<EventItem> currentStage1Events;
  final List<EventItem> currentStage2Events;
  final List<EventItem> upcomingStage1Events;
  final List<EventItem> upcomingStage2Events;

  CurrentAndUpcomingEvents({
    required this.currentStage1Events,
    required this.currentStage2Events,
    required this.upcomingStage1Events,
    required this.upcomingStage2Events,
  });
}

class HomePage extends StatefulWidget {
  final DateTime? testTime;
  final EventItem? selectedEvent;

  const HomePage({Key? key, this.testTime, this.selectedEvent})
    : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- UI State ---
  final List<String> backgroundImages = [
    "assets/JFB-27.jpg", "assets/JFB-4.jpg", "assets/JFB-3.jpg", "assets/JFB-8.jpg",
    "assets/JFB-15.jpg", "assets/JFB-10.jpg", "assets/JFB-22.jpg", "assets/JFB-6.jpg",
  ];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  Timer? _timetableUpdateTimer;
  // Loading/error state comes from ScheduleDataService via Provider

  // REMOVED: Instance of SupabaseService

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    // Data is fetched by ScheduleDataService automatically upon its initialization

    // Timer to trigger rebuilds to update the "Now/Next" display
    _timetableUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        print("⏰ Timetable update timer triggered - rebuilding HomePage state");
        // No need to fetch, just rebuild to re-evaluate time against existing data
        setState(() {});
      } else {
        timer.cancel();
      }
    });

    // Handle pre-selected event after the first frame (giving provider time to potentially load)
    if (widget.selectedEvent != null) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _findAndNavigateToSelectedEvent(widget.selectedEvent!);
          }
       });
    }
  }

   // Helper to find which day the selected event belongs to and navigate
    // Helper to find which day the selected event belongs to and navigate
 void _findAndNavigateToSelectedEvent(EventItem selectedEventTarget) {
   // Access provider once using read as it's an action
   final scheduleService = context.read<ScheduleDataService>();
   int? targetDay;
   EventItem? foundEvent; // Use the actual event from the provider's list

   // Function to search a list for the event using firstWhereOrNull
   EventItem? searchList(List<ScheduleItem> list) {
      for (var item in list) {
         // Combine stage events safely, filtering out potential nulls within the spread
         final eventsInSlot = [...?item.stage1Events, ...?item.stage2Events];
         // Use firstWhereOrNull - it returns EventItem? directly (the item or null)
         final found = eventsInSlot.firstWhereOrNull(
             (e) => e.title == selectedEventTarget.title &&
                    e.time == selectedEventTarget.time &&
                    e.stage == selectedEventTarget.stage);
         if (found != null) return found; // Return the found event
      }
      return null; // Return null if not found in any item in the list
   }

   // Check Day 1
   foundEvent = searchList(scheduleService.day1ScheduleData);
   if (foundEvent != null) {
     targetDay = 1;
   } else {
      // Check Day 2 if not found in Day 1
      foundEvent = searchList(scheduleService.day2ScheduleData);
      if (foundEvent != null) {
         targetDay = 2;
      }
   }

   // --- Navigation logic remains the same ---
   if (targetDay != null && foundEvent != null) {
      _navigateToSelectedEvent(foundEvent, targetDay); // Pass found event and determined day
   } else {
      print("❌ Could not find pre-selected event in schedule data on either day.");
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Could not locate the specified event in the schedule."), duration: Duration(seconds: 2),)
          );
      }
   }
 }


  void _startAutoScroll() { /* ... unchanged ... */
    if (backgroundImages.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!mounted) { timer.cancel(); return; }
        if (_pageController.hasClients) {
          int nextPage = (_currentPage + 1) % backgroundImages.length;
          _pageController.animateToPage( nextPage, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut,);
        }
      });
    }
  }

  // REMOVED: _loadEventsForHomepage() - Data is managed by ScheduleDataService

  @override
  void dispose() { /* ... unchanged ... */
    _autoScrollTimer?.cancel();
    _timetableUpdateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // *** Use Provider to watch ScheduleDataService ***
    final scheduleService = context.watch<ScheduleDataService>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        return Container( /* ... Main Background Container ... */
          color: const Color(0xFFFFF5F5),
          child: Container(
            decoration: const BoxDecoration( /* ... gradient ... */
               gradient: LinearGradient( begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ Color.fromRGBO(10, 56, 117, 0.15), Color.fromRGBO(191, 28, 36, 0.15)],),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  SingleChildScrollView( // Scrollable content
                    child: Column(
                      children: [
                        // --- Image Carousel (remains the same) ---
                         SizedBox( width: double.infinity, height: screenHeight * 0.6, child: Stack( children: [ PageView.builder( controller: _pageController, itemCount: backgroundImages.length, onPageChanged: (index) => setState(() => _currentPage = index), itemBuilder: (context, index) { final isLadyInKimono = backgroundImages[index] == "assets/JFB-27.jpg"; Widget image = Image.asset( backgroundImages[index], fit: BoxFit.cover, width: double.infinity, height: screenHeight * 0.6, alignment: isLadyInKimono ? Alignment.topCenter : Alignment.center,); if (isLadyInKimono) { image = Transform.scale(scale: 1.1, child: Align( alignment: Alignment.topCenter, child: image,),); } return image; },), Positioned( bottom: 10, left: 0, right: 0, child: Row( mainAxisAlignment: MainAxisAlignment.center, children: List.generate( backgroundImages.length, (index) => AnimatedContainer( duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4,), width: _currentPage == index ? 10 : 6, height: _currentPage == index ? 10 : 6, decoration: BoxDecoration( color: _currentPage == index ? Colors.white : Colors.white70, shape: BoxShape.circle,),),),),), ],),),
                        SizedBox(height: screenHeight * 0.02),
                        // --- Live Timetable Section ---
                        _buildLiveTimetableSection(screenWidth, scheduleService), // Pass service
                        _buildSocialMediaIcons(screenWidth),
                        _buildSponsorsSection(screenWidth),
                        const SizedBox(height: 125), // Bottom Padding
                      ],
                    ),
                  ),
                   // --- Settings Button (remains the same) ---
                  Positioned( top: MediaQuery.of(context).padding.top + screenHeight * 0.015, right: screenWidth * 0.05, child: GestureDetector( onTap: () => Navigator.pushNamed(context, SettingsPage.routeName), child: Material( color: Colors.transparent, child: Container( width: 55, height: 55, decoration: BoxDecoration( color: Theme.of(context).colorScheme.surface.withOpacity(0.85), borderRadius: BorderRadius.circular(40), boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.15), blurRadius: 8, spreadRadius: 1, ),],), child: const Padding( padding: EdgeInsets.all(10.0), child: Icon( Icons.settings, size: 30, color: Colors.black54,),),),),),),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Widget Builder for Live Timetable ---
  Widget _buildLiveTimetableSection(double screenWidth, ScheduleDataService scheduleService) {
     // Determine which day it currently is
     final now = widget.testTime ?? DateTime.now();
     // TODO: Make festival dates dynamic or configurable
     final festivalDay1Start = DateTime(now.year, 4, 26); // Assuming April 26th
     final festivalDay2Start = DateTime(now.year, 4, 27); // Assuming April 27th
     final bool isDay1 = now.isAfter(festivalDay1Start) && now.isBefore(festivalDay2Start);

     // Get state from the provider for the CURRENT day
     bool isLoading = isDay1 ? scheduleService.isLoadingDay1 : scheduleService.isLoadingDay2;
     String? errorMessage = isDay1 ? scheduleService.errorDay1 : scheduleService.errorDay2;
     final List<ScheduleItem> scheduleList = isDay1 ? scheduleService.day1ScheduleData : scheduleService.day2ScheduleData;

     // Check if outside festival dates entirely
     final festivalEnd = DateTime(now.year, 4, 27, 23, 59); // Approx end
     if (now.isBefore(festivalDay1Start) || now.isAfter(festivalEnd)) {
         return Padding( padding: const EdgeInsets.all(16.0), child: Container( padding: const EdgeInsets.all(16), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),],), child: const Center( child: Text( "Live Timetable is available during the festival (Apr 26-27).", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),),),);
     }


     if (isLoading) { /* ... Loading Indicator ... */
        return const Padding( padding: EdgeInsets.symmetric(vertical: 40.0), child: Center(child: CircularProgressIndicator()),);
     }
     if (errorMessage != null) { /* ... Error Message ... */
         return Padding( padding: const EdgeInsets.all(16.0), child: Container( padding: const EdgeInsets.all(16), decoration: BoxDecoration( color: Colors.red.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.shade200)), child: Center( child: Text( "Error loading schedule: $errorMessage", style: const TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center,),),),);
     }
     // Use the scheduleList obtained from the provider for the current day
     if (scheduleList.isEmpty) { /* ... No schedule message ... */
         return Padding( padding: const EdgeInsets.all(16.0), child: Container( padding: const EdgeInsets.all(16), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),],), child: Center( child: Text( "No schedule information available for ${isDay1 ? 'Today (Day 1)' : 'Today (Day 2)'}.", style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,),),),);
     }

     // Calculate current/upcoming using the current day's data
     final currentAndUpcoming = _getCurrentAndUpcomingEvents(scheduleList, now, isDay1);

     return Padding( padding: const EdgeInsets.all(16.0),
      child: Column( children: [
          if (currentAndUpcoming.currentStage1Events.isNotEmpty || currentAndUpcoming.currentStage2Events.isNotEmpty) ...[
            _buildEventSection( "🎤 Now Happening", currentAndUpcoming.currentStage1Events, currentAndUpcoming.currentStage2Events, screenWidth, isDay1 ? 1 : 2, isCurrent: true,), // Pass dayNumber
            const SizedBox(height: 20),
          ],
          if (currentAndUpcoming.upcomingStage1Events.isNotEmpty || currentAndUpcoming.upcomingStage2Events.isNotEmpty)
            _buildEventSection( "⏭️ Up Next", currentAndUpcoming.upcomingStage1Events, currentAndUpcoming.upcomingStage2Events, screenWidth, isDay1 ? 1 : 2, isCurrent: false,), // Pass dayNumber
          if (currentAndUpcoming.currentStage1Events.isEmpty && currentAndUpcoming.currentStage2Events.isEmpty && currentAndUpcoming.upcomingStage1Events.isEmpty && currentAndUpcoming.upcomingStage2Events.isEmpty)
             Padding( padding: const EdgeInsets.symmetric(vertical: 20.0), child: Text( "No current or upcoming events found for ${isDay1 ? 'Day 1' : 'Day 2'}.", style: TextStyle(fontSize: 16, color: Colors.grey.shade700), textAlign: TextAlign.center,),),
        ],),);
  }

  // Logic to find current/upcoming (Uses List<ScheduleItem> for the specific day)
  CurrentAndUpcomingEvents _getCurrentAndUpcomingEvents( List<ScheduleItem> scheduleList, DateTime now, bool isDay1, ) {
      // ... (Implementation remains the same as previous version, using the passed scheduleList) ...
       List<EventItem> currentStage1 = []; List<EventItem> currentStage2 = []; List<EventItem> allUpcoming = [];
       final int currentYear = now.year; final int currentMonth = now.month; final int currentDay = isDay1 ? 26 : 27;

       for (final item in scheduleList) {
          final events = [...?item.stage1Events, ...?item.stage2Events];
          for (final event in events) {
             if (event == null || event.title.isEmpty || !event.time.contains('-')) continue;
             try {
                final timeParts = event.time.split('-');
                final eventStart = _parseEventDateTime(timeParts[0].trim(), currentYear, currentMonth, currentDay);
                final eventEnd = _parseEventDateTime(timeParts[1].trim(), currentYear, currentMonth, currentDay);
                if (eventStart.year == 9999 || eventEnd.year == 9999) continue;
                if (now.isAfter(eventStart) && now.isBefore(eventEnd)) { if (event.stage == 'Stage 1') currentStage1.add(event); else if (event.stage == 'Stage 2') currentStage2.add(event); }
                else if (eventStart.isAfter(now)) { allUpcoming.add(event); }
             } catch (e) { print("⚠️ Error processing event '${event.title}' time '${event.time}': $e"); continue; }
          }
       }
       List<EventItem> upcomingStage1 = []; List<EventItem> upcomingStage2 = [];
       if (allUpcoming.isNotEmpty) {
          allUpcoming.sort((a, b) { final aTime = _parseEventDateTime(a.time.split('-')[0].trim(), currentYear, currentMonth, currentDay); final bTime = _parseEventDateTime(b.time.split('-')[0].trim(), currentYear, currentMonth, currentDay); if (aTime.year == 9999) return 1; if (bTime.year == 9999) return -1; return aTime.compareTo(bTime); });
          final firstUpcomingTime = _parseEventDateTime( allUpcoming.first.time.split('-')[0].trim(), currentYear, currentMonth, currentDay);
          if (firstUpcomingTime.year != 9999) {
             final nextEvents = allUpcoming.where((event) => _parseEventDateTime(event.time.split('-')[0].trim(), currentYear, currentMonth, currentDay).isAtSameMomentAs(firstUpcomingTime)).toList();
             upcomingStage1 = nextEvents.where((e) => e.stage == 'Stage 1').toList(); upcomingStage2 = nextEvents.where((e) => e.stage == 'Stage 2').toList();
          }
       }
       return CurrentAndUpcomingEvents( currentStage1Events: currentStage1, currentStage2Events: currentStage2, upcomingStage1Events: upcomingStage1, upcomingStage2Events: upcomingStage2,);
    }

  // Helper to parse HH:MM (Keep as is)
  DateTime _parseEventDateTime(String hhmm, int year, int month, int day) {
      try { final parts = hhmm.split(':'); if (parts.length != 2) return DateTime(9999); final hour = int.parse(parts[0]); final minute = int.parse(parts[1]); return DateTime(year, month, day, hour, minute); } catch (e) { print("Error parsing time string '$hhmm': $e"); return DateTime(9999); }
   }

  // Build section - Pass dayNumber
  Widget _buildEventSection( String title, List<EventItem> stage1Events, List<EventItem> stage2Events, double screenWidth, int dayNumber, { required bool isCurrent,}) {
      List<EventItem> combinedEvents = [...stage1Events, ...stage2Events];
      final now = widget.testTime ?? DateTime.now();
      final int currentDay = dayNumber == 1 ? 26 : 27; // Use passed dayNumber

       combinedEvents.sort((a, b) {
           final aTime = _parseEventDateTime(a.time.split('-')[0].trim(), now.year, now.month, currentDay);
           final bTime = _parseEventDateTime(b.time.split('-')[0].trim(), now.year, now.month, currentDay);
           if (aTime.year == 9999) return 1; if (bTime.year == 9999) return -1;
           return aTime.compareTo(bTime);
       });

      return Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
         Padding( padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text( title, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB63E41)),),),
         const SizedBox(height: 8),
         ...combinedEvents.map((event) => _buildEventCard(event, dayNumber, isCurrent, screenWidth),), // Pass dayNumber
      ],);
   }

  // Navigate helper - Accepts day number
  void _navigateToSelectedEvent(EventItem event, int dayToOpen) {
      print("Navigating to Timetable (Day $dayToOpen) for event: ${event.title}");
      if (!mounted) return;
      Navigator.push( context, PageRouteBuilder( transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => MainScreen( initialIndex: 2, selectedEvent: event, selectedDay: dayToOpen, ),
          transitionsBuilder: (_, animation, __, child) { return SlideTransition( position: Tween( begin: const Offset(1, 0), end: Offset.zero,).chain(CurveTween(curve: Curves.easeInOut)).animate(animation), child: child,);},),);
  }

  // Event Card builder - Accepts dayNumber for navigation
   Widget _buildEventCard(EventItem event, int dayNumber, bool isCurrent, double screenWidth) {
      return GestureDetector( onTap: () => _navigateToSelectedEvent(event, dayNumber),
       child: Padding( padding: const EdgeInsets.symmetric(vertical: 6.0),
         child: Stack( clipBehavior: Clip.none, children: [
             Container( padding: const EdgeInsets.only(left: 35, right: 16, top: 10, bottom: 12), margin: const EdgeInsets.only(left: 15.0), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.08), blurRadius: 6, spreadRadius: 1, offset: Offset(0, 2)),],),
               child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                   Align( alignment: Alignment.topRight, child: Text( event.stage, style: TextStyle( color: Color(0xffB63E41), fontWeight: FontWeight.bold, fontSize: 14),),),
                   Text( event.title, style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold,), maxLines: 2, overflow: TextOverflow.ellipsis,),
                   const SizedBox(height: 4),
                   Text(event.time, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                   if (isCurrent) Padding( padding: const EdgeInsets.only(top: 6.0), child: Container( padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8,), decoration: BoxDecoration( color: Colors.orangeAccent.shade700, borderRadius: BorderRadius.circular(4),), child: const Text( "LIVE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),),),),
                 ],),),
             Positioned( top: -15, left: 0,
               child: Container( padding: const EdgeInsets.all(6), decoration: const BoxDecoration( color: Colors.white, shape: BoxShape.circle, boxShadow: [ BoxShadow( color: Colors.black12, blurRadius: 5, spreadRadius: 1,),],),
                  child: ClipOval( child: SizedBox( width: 40, height: 40,
                        child: event.iconImage.isNotEmpty ? Image.asset( event.iconImage, fit: BoxFit.contain, errorBuilder: (c,e,s)=> Icon(Icons.event, size: 20, color: Colors.grey)) : Icon(Icons.event, size: 24, color: Colors.grey),),)),),
           ],),),);
   }
  // Social Media Icons Section (Keep as is)
  Widget _buildSocialMediaIcons(double screenWidth) { /* ... */
       return Container( margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),],),
        child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildIcon("assets/instagram.png", "https://www.instagram.com/japanfestivalboston?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==",),
            _buildIcon("assets/facebook.png", "https://www.facebook.com/JapanFestivalBoston",),
            _buildIcon("assets/website.png", "https://www.japanfestivalboston.org",),
          ],),);
   }
  // Icon Builder (Keep as is)
  Widget _buildIcon(String imagePath, String url) { /* ... */
      return GestureDetector( onTap: () async { final Uri uri = Uri.parse(url); try { if (await canLaunchUrl(uri)) { await launchUrl(uri, mode: LaunchMode.externalApplication); } else { print('Could not launch $url'); } } catch (e) { print('Error launching $url: $e'); } },
        child: Container( padding: const EdgeInsets.all(8), decoration: BoxDecoration( color: Colors.white, shape: BoxShape.circle, boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),],),
          child: Image.asset(imagePath, height: 30),),);
  }
  // Sponsors Section (Keep as is)
  Widget _buildSponsorsSection(double screenWidth) { /* ... */
       return Container( margin: EdgeInsets.all(16), padding: EdgeInsets.all(16), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [ BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),],),
       child: Column( children: [
           _buildSponsorCategory("Sustainability", "assets/sponsors/Takeda.jpg"), SizedBox(height: 7),
           _buildSponsorCategory("Airline", "assets/sponsors/jal.jpg"), SizedBox(height: 7),
           _buildSponsorCategory( "Transportation", "assets/sponsors/yamatotransport.jpg",), SizedBox(height: 3),
           _buildCorporateSponsors(), SizedBox(height: 3),
           _buildIndividualSponsors(), SizedBox(height: 3),
           _buildJfbOrganizers(), SizedBox(height: 3),
           _buildSupportingSponsors(), SizedBox(height: 5),
         ],),);
   }
   // Sponsor Category Builder (Keep as is)
   Widget _buildSponsorCategory(String title, String imagePath) { /* ... */
       return Column( children: [
           Container( padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 26), margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10), decoration: BoxDecoration( color: Colors.grey[200], borderRadius: BorderRadius.circular(40),), child: Text( title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w300),),),
           Image.asset(imagePath, height: 65),
         ],);
   }
  // Corporate Sponsors Builder (Keep as is)
  Widget _buildCorporateSponsors() { /* ... */
     List<String> corporateLogos = [ "assets/sponsors/meetboston.jpg", "assets/sponsors/sanipak.png", "assets/sponsors/chopvalue.png", "assets/sponsors/mitsubishi.jpg", "assets/sponsors/SDT.jpg", "assets/sponsors/senko.png", "assets/sponsors/yamamoto.jpg", "assets/sponsors/openwater.png", "assets/sponsors/idamerica.png", "assets/sponsors/downtown.png", ];
     return Column( children: [
         Container( padding: EdgeInsets.symmetric(vertical: 6, horizontal: 26), margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10), decoration: BoxDecoration( color: Colors.grey[200], borderRadius: BorderRadius.circular(40),), child: Text( "Corporate", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),),),
         GridView.builder( shrinkWrap: true, physics: NeverScrollableScrollPhysics(), padding: EdgeInsets.symmetric(horizontal: 10), itemCount: corporateLogos.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 10, childAspectRatio: 3,), itemBuilder: (context, index) { return Center( child: SizedBox( height: MediaQuery.of(context).size.height * 0.15, width: MediaQuery.of(context).size.width * 0.3, child: Image.asset(corporateLogos[index], fit: BoxFit.contain),),); },),
       ],);
   }
   // Individual Sponsors Builder (Keep as is)
   Widget _buildIndividualSponsors() { /* ... */
       return Padding( padding: EdgeInsets.only(top: 10, bottom: 10), child: Column( children: [
           Container( padding: EdgeInsets.symmetric(vertical: 6, horizontal: 26), margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10), decoration: BoxDecoration( color: Colors.grey[200], borderRadius: BorderRadius.circular(40),), child: Text( "Individual", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),),),
           Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ Text( "   NK JPN\nFoundation", style: TextStyle(fontSize: 19, height: 1.25),), Text( "William\nHawes", style: TextStyle(fontSize: 19, height: 1.25),),],),
         ],),);
   }
  // JFB Organizers Builder (Keep as is)
  Widget _buildJfbOrganizers() { /* ... */
      return Column( children: [
          Container( padding: EdgeInsets.symmetric(vertical: 6, horizontal: 26), margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10), decoration: BoxDecoration( color: Colors.grey[200], borderRadius: BorderRadius.circular(40),), child: Text( "JFB Organizers", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),),),
          Wrap( alignment: WrapAlignment.center, spacing: 20, runSpacing: 10, children: [
              SizedBox( height: MediaQuery.of(context).size.height * 0.11, width: MediaQuery.of(context).size.width * 0.25, child: Image.asset( "assets/sponsors/showa.jpg", fit: BoxFit.contain,),),
              Column( children: [ SizedBox( height: MediaQuery.of(context).size.height * 0.08, width: MediaQuery.of(context).size.width * 0.2, child: Image.asset( "assets/sponsors/bosJapan.png", fit: BoxFit.contain,),), SizedBox(height: 4), Column( children: [ Text( "Boston Japan", style: TextStyle(fontSize: 12, height: 1),), Text( "Community Hub", style: TextStyle(fontSize: 12, height: 1.1),),],),],),
              SizedBox( height: MediaQuery.of(context).size.height * 0.11, width: MediaQuery.of(context).size.width * 0.25, child: Image.asset( "assets/sponsors/JAGB.jpg", fit: BoxFit.contain,),),
            ],),
        ],);
   }
    // Supporting Sponsors Builder (Keep as is)
   Widget _buildSupportingSponsors() { /* ... */
       return Column( children: [
           Container( padding: EdgeInsets.symmetric(vertical: 6, horizontal: 26), margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10), decoration: BoxDecoration( color: Colors.grey[200], borderRadius: BorderRadius.circular(40),), child: Text( "Supporting Sponsors", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),),), // Corrected title
           Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
               SizedBox( height: MediaQuery.of(context).size.height * 0.12, width: MediaQuery.of(context).size.width * 0.35, child: Image.asset( "assets/sponsors/consultatejapan.jpg", fit: BoxFit.contain,),),
               SizedBox( height: MediaQuery.of(context).size.height * 0.12, width: MediaQuery.of(context).size.width * 0.35, child: Image.asset( "assets/sponsors/JSoc.jpg", fit: BoxFit.contain,),),
             ],),
         ],);
   }

} // End of _HomePageState