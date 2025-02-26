//import 'dart:js';

import 'package:event_app/app/configs/colors.dart';
import 'package:event_app/app/resources/constant/named_routes.dart';
import 'package:event_app/bloc/event_cubit.dart';
import 'package:event_app/data/event_model.dart';
import 'package:event_app/ui/pages/profile_page.dart';
import 'package:event_app/ui/widgets/card_event_this_month.dart';
import 'package:event_app/ui/widgets/card_popular_event.dart';
import 'package:event_app/ui/widgets/custom_app_bar.dart';
import 'package:event_app/ui/widgets/my_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: Size(0, 0), child: CustomAppBar()),
      bottomNavigationBar: const MyNavigationBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24),
          child: BlocProvider(
            create: (_) => EventCubit()..loadEventData(),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildSearch(),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Event",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "View All",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.greyTextColor),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                    if (state is EventError) {
                      return Center(child: Text(state.message));
                    } else if (state is EventLoaded) {
                      return _listPopularEvent(state.events);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Event This Month",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        "View All",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.greyTextColor),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                    if (state is EventError) {
                      return Center(child: Text(state.message));
                    } else if (state is EventLoaded) {
                      return _listEventThisMonth(state.events);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Location",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Row(children: [
                  SizedBox(width: 4),
                  Text(
                    "india",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.greyTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]),
              ],
            ),
            GestureDetector(
              onTap: () {
                // Navigate to the specific page here

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://avatars.githubusercontent.com/u/85386116?s=400&u=81f5587a31a3c80319ed97931c1001636a663198&v=4"),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  _buildSearch() => Container(
        height: 48,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: AppColors.whiteColor,
        ),
        child: Row(
          children: [
            Image.asset('assets/images/search.png', width: 16),
            const SizedBox(width: 8),
            const Text(
              "Search event...",
              style: TextStyle(
                  color: AppColors.greyTextColor, fontWeight: FontWeight.w400),
            )
          ],
        ),
      );

  _listPopularEvent(List<EventModel> events) => Container(
        width: double.infinity,
        height: 270,
        padding: const EdgeInsets.only(left: 16),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.pushNamed(
              arguments: events[index].toJson(),
              context,
              NamedRoutes.detailScreen,
            ),
            child: CardPopularEvent(eventModel: events[index]),
          ),
        ),
      );

  _listEventThisMonth(List<EventModel> events) => Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: events.length,
          reverse: true,
          itemBuilder: (context, index) => BlocBuilder<EventCubit, EventState>(
            builder: (context, state) {
              if (state is EventError) {
                return const Center(child: Text("Error"));
              } else if (state is EventLoaded) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      arguments: events[index].toJson(),
                      context,
                      NamedRoutes.detailScreen),
                  child: CardEventThisMonth(eventModel: events[index]),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );
}
