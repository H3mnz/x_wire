import 'package:flutter/material.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

import '../../../shared/theme/colors.dart';
import '../../../shared/widgets/custom_tooltip.dart';

class ConnectionSwitch extends StatelessWidget {
  final VpnStage stage;
  final VoidCallback onPressed;
  const ConnectionSwitch({super.key, required this.stage, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final connected = stage == VpnStage.connected;
    final disconnected = stage == VpnStage.disconnected;
    final message = connected ? 'Tap to disconnect' : 'Tap to connect';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusLight(connected: connected, color: AppColors.green),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          width: 80,
          child: CustomTooltip(
            message: message,
            cursor: SystemMouseCursors.click,
            color: AppColors.color1,
            child: GestureDetector(
              onTap: onPressed,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      height: 200,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff222126),
                            Color(0xff323136),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: const [
                          BoxShadow(blurRadius: 1),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xff212025),
                          boxShadow: const [
                            BoxShadow(blurRadius: 5),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 6,
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    left: 10,
                    right: 10,
                    top: connected
                        ? 10
                        : disconnected
                            ? 90
                            : 90,
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 90,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xff36353B),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [
                              BoxShadow(blurRadius: 16),
                            ],
                          ),
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.3),
                                          Colors.black.withOpacity(0.01),
                                          Colors.black.withOpacity(0.005),
                                        ],
                                        stops: const [0, 0.6, 0.9],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.05),
                                          ],
                                          stops: const [0, 0.3],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.3),
                                          Colors.black.withOpacity(0.01),
                                          Colors.black.withOpacity(0.005),
                                        ],
                                        stops: const [0, 0.6, 0.9],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.05),
                                          ],
                                          stops: const [0, 0.3],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        StatusLight(connected: !connected, color: AppColors.red),
      ],
    );
  }
}

class StatusLight extends StatelessWidget {
  const StatusLight({
    super.key,
    required this.connected,
    required this.color,
  });

  final bool connected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 16,
      width: 12,
      clipBehavior: Clip.antiAlias,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: connected ? color : color.withOpacity(0.1),
        boxShadow: [
          const BoxShadow(
            blurRadius: 1,
            color: Colors.black,
            offset: Offset(2, 1),
          ),
          BoxShadow(
            blurRadius: 6,
            color: connected ? color : color.withOpacity(0.1),
            offset: const Offset(2, 0),
          ),
        ],
        border: Border.all(color: Colors.black54, width: 1.5, strokeAlign: BorderSide.strokeAlignOutside),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: connected ? Colors.white.withOpacity(0.3) : color.withOpacity(0.1),
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 2,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                blurRadius: 1,
                color: connected ? Colors.white : color.withOpacity(0.1),
                offset: const Offset(-1, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
