import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final connectivityStreamProvider = StreamProvider<ConnectivityResult>((ref) {
  return ref.watch(connectivityProvider).onConnectivityChanged;
});

final isConnectedProvider = Provider<bool>((ref) {
  final connectivityStatus = ref.watch(connectivityStreamProvider);
  return connectivityStatus.when(
    data: (data) => data != ConnectivityResult.none,
    loading: () => true,
    error: (_, __) => false,
  );
});
