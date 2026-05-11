import 'package:flutter/material.dart';

import '../../core/theme/pk_design.dart';
import '../loaders/app_skeleton.dart';

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({
    this.message = 'Memuat data...',
    this.cardCount = 3,
    super.key,
  });

  final String message;
  final int cardCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: message,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: PkColors.muted,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: PkSpacing.md),
          ...List.generate(
            cardCount,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: PkSpacing.md),
              child: AppSkeletonCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      clean: true,
      padding: const EdgeInsets.all(PkSpacing.xxl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PkIconBox(icon: icon, tone: PkTone.gray, size: 58, iconSize: 28),
              const SizedBox(height: PkSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: PkSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: PkColors.text2,
                      height: 1.55,
                    ),
              ),
              if (action != null) ...[
                const SizedBox(height: PkSpacing.lg),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.title,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Coba lagi',
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: PkCard(
        tint: PkColors.redSoft,
        borderColor: PkColors.red.withValues(alpha: 0.22),
        padding: const EdgeInsets.all(PkSpacing.xxl),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PkIconBox(icon: Icons.error_outline_rounded, tone: PkTone.red),
            const SizedBox(width: PkSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: PkColors.red,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: PkSpacing.xs),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PkColors.text2,
                          height: 1.55,
                        ),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: PkSpacing.lg),
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(retryLabel),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppAsyncView<T> extends StatelessWidget {
  const AppAsyncView({
    required this.isLoading,
    required this.data,
    required this.builder,
    this.error,
    this.onRetry,
    this.loadingMessage = 'Memuat data...',
    this.emptyTitle = 'Data belum tersedia',
    this.emptyMessage = 'Coba ubah filter atau periksa kembali nanti.',
    this.isEmpty,
    super.key,
  });

  final bool isLoading;
  final T? data;
  final Object? error;
  final VoidCallback? onRetry;
  final String loadingMessage;
  final String emptyTitle;
  final String emptyMessage;
  final bool Function(T data)? isEmpty;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return AppLoadingState(message: loadingMessage);
    if (error != null) {
      return AppErrorState(
        title: 'Terjadi kendala',
        message: error.toString(),
        onRetry: onRetry,
      );
    }
    final resolved = data;
    if (resolved == null || (isEmpty?.call(resolved) ?? false)) {
      return AppEmptyState(title: emptyTitle, message: emptyMessage);
    }
    return builder(context, resolved);
  }
}
