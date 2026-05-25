import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';

import '../../controllers/task_controller.dart';

class ProfileScreen
    extends StatelessWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    final taskCtrl =
        Get.find<TaskController>();

    final isDark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
          isDark

              ? AppColors
                  .backgroundDark

              : AppColors
                  .background,

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets
                  .all(
            20,
          ),

          child: Column(

            children: [

              // HEADER

              Container(

                padding:
                    const EdgeInsets
                        .all(
                  24,
                ),

                decoration:
                    BoxDecoration(

                  gradient:
                      AppColors
                          .primaryGradient,

                  borderRadius:
                      BorderRadius
                          .circular(
                    28,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          AppColors
                              .primary
                              .withOpacity(
                        0.25,
                      ),

                      blurRadius:
                          24,

                      offset:
                          const Offset(
                        0,
                        12,
                      ),
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    // AVATAR

                    Container(

                      width: 95,

                      height: 95,

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          100,
                        ),
                      ),

                      child: Icon(

                        Icons
                            .person_rounded,

                        size: 54,

                        color:
                            AppColors
                                .primary,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    Text(

                      'TaskFlow User',

                      style:
                          GoogleFonts
                              .plusJakartaSans(

                        fontSize: 22,

                        fontWeight:
                            FontWeight
                                .w800,

                        color:
                            Colors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(

                      'Manage Your Productivity Smarter',

                      textAlign:
                          TextAlign
                              .center,

                      style:
                          GoogleFonts
                              .plusJakartaSans(

                        fontSize: 13,

                        color: Colors
                            .white
                            .withOpacity(
                          0.85,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // STATS

              Row(

                children: [

                  Expanded(

                    child:
                        _StatCard(

                      title:
                          'Total',

                      value: taskCtrl
                          .tasks
                          .length
                          .toString(),

                      icon:
                          Icons
                              .task_alt_rounded,

                      color:
                          AppColors
                              .primary,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(

                    child:
                        _StatCard(

                      title:
                          'Done',

                      value: taskCtrl
                          .tasks
                          .where(
                        (task) {

                          return task
                              .isDone;
                        },
                      )
                          .length
                          .toString(),

                      icon:
                          Icons
                              .check_circle_rounded,

                      color:
                          AppColors
                              .success,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              Row(

                children: [

                  Expanded(

                    child:
                        _StatCard(

                      title:
                          'Pending',

                      value: taskCtrl
                          .tasks
                          .where(
                        (task) {

                          return !task
                              .isDone;
                        },
                      )
                          .length
                          .toString(),

                      icon:
                          Icons
                              .schedule_rounded,

                      color:
                          AppColors
                              .warning,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(

                    child:
                        _StatCard(

                      title:
                          'Progress',

                      value:
                          '${_calculateProgress(taskCtrl)}%',

                      icon:
                          Icons
                              .insights_rounded,

                      color:
                          AppColors
                              .info,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 26,
              ),

              // MENU

              _MenuTile(

                icon:
                    Icons
                        .edit_rounded,

                title:
                    'Edit Profile',

                subtitle:
                    'Ubah data profile',

                onTap: () {

                  Get.snackbar(
                    'Info',

                    'Fitur segera hadir',
                  );
                },
              ),

              _MenuTile(

                icon:
                    Icons
                        .dark_mode_rounded,

                title:
                    'Dark Mode',

                subtitle:
                    'Atur tampilan aplikasi',

                onTap: () {

                  Get.changeThemeMode(

                    Get.isDarkMode

                        ? ThemeMode
                            .light

                        : ThemeMode
                            .dark,
                  );
                },
              ),

              _MenuTile(

                icon:
                    Icons
                        .notifications_rounded,

                title:
                    'Notifications',

                subtitle:
                    'Pengaturan notifikasi',

                onTap: () {},
              ),

              _MenuTile(

                icon:
                    Icons
                        .info_rounded,

                title:
                    'About App',

                subtitle:
                    'TaskFlow v1.0',

                onTap: () {},
              ),

              const SizedBox(
                height: 16,
              ),

              // LOGOUT

              GestureDetector(

                onTap: () {

                  Get.offAllNamed(
                    '/login',
                  );
                },

                child: Container(

                  height: 56,

                  decoration:
                      BoxDecoration(

                    color:
                        AppColors
                            .error,

                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                  ),

                  child: Center(

                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [

                        const Icon(
                          Icons
                              .logout_rounded,

                          color:
                              Colors
                                  .white,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Text(

                          'Logout',

                          style:
                              GoogleFonts
                                  .plusJakartaSans(

                            fontSize:
                                15,

                            fontWeight:
                                FontWeight
                                    .w700,

                            color:
                                Colors
                                    .white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateProgress(
    TaskController ctrl,
  ) {

    if (ctrl.tasks.isEmpty) {
      return 0;
    }

    final done =
        ctrl.tasks.where(
      (task) {

        return task.isDone;
      },
    ).length;

    return ((done /
                ctrl.tasks.length) *
            100)
        .toInt();
  }
}

class _StatCard
    extends StatelessWidget {

  final String title;

  final String value;

  final IconData icon;

  final Color color;

  const _StatCard({

    required this.title,

    required this.value,

    required this.icon,

    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow:
            AppColors.cardShadow,
      ),

      child: Column(

        children: [

          Container(

            padding:
                const EdgeInsets
                    .all(
              10,
            ),

            decoration:
                BoxDecoration(

              color:
                  color.withOpacity(
                0.12,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                14,
              ),
            ),

            child: Icon(

              icon,

              color: color,

              size: 24,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          Text(

            value,

            style:
                GoogleFonts
                    .plusJakartaSans(

              fontSize: 24,

              fontWeight:
                  FontWeight.w800,

              color:
                  AppColors
                      .textPrimary,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(

            title,

            style:
                GoogleFonts
                    .plusJakartaSans(

              fontSize: 12,

              color:
                  AppColors
                      .textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile
    extends StatelessWidget {

  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const _MenuTile({

    required this.icon,

    required this.title,

    required this.subtitle,

    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),

        padding:
            const EdgeInsets.all(
          16,
        ),

        decoration:
            BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          boxShadow:
              AppColors.cardShadow,
        ),

        child: Row(

          children: [

            Container(

              padding:
                  const EdgeInsets
                      .all(
                12,
              ),

              decoration:
                  BoxDecoration(

                color:
                    AppColors
                        .primarySurface,

                borderRadius:
                    BorderRadius
                        .circular(
                  14,
                ),
              ),

              child: Icon(

                icon,

                color:
                    AppColors
                        .primary,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    title,

                    style:
                        GoogleFonts
                            .plusJakartaSans(

                      fontSize: 14,

                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(

                    subtitle,

                    style:
                        GoogleFonts
                            .plusJakartaSans(

                      fontSize: 12,

                      color:
                          AppColors
                              .textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .arrow_forward_ios_rounded,

              size: 16,

              color:
                  AppColors
                      .textHint,
            ),
          ],
        ),
      ),
    );
  }
}