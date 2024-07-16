import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PollMenuItems {
  addPoll,
  editPoll,
  deletePoll,
  closePoll,
  seeClosedPolls,
}

class PollOwnerMenu extends StatelessWidget {
  final Function()? onAddPoll;
  final Function()? onEditPoll;
  final Function()? onDeletePoll;
  final Function()? onClosePoll;
  final Function()? onSeeClosedPolls;
  final bool? isOnAddPollLoading;
  final bool? isOnEditPollLoading;
  final bool? isOnDeletePollLoading;
  final bool? isOnClosePollLoading;
  final bool? isOnSeeClosedPollsLoading;

  const PollOwnerMenu({
    super.key,
    this.onAddPoll,
    this.onEditPoll,
    this.onDeletePoll,
    this.onClosePoll,
    this.onSeeClosedPolls,
    this.isOnAddPollLoading,
    this.isOnEditPollLoading,
    this.isOnDeletePollLoading,
    this.isOnClosePollLoading,
    this.isOnSeeClosedPollsLoading,
  });

  Widget _buildLoadingIndicator(String text) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  PopupMenuEntry<PollMenuItems> _buildMenuItem({
    required PollMenuItems value,
    required Function()? onTap,
    required String text,
    bool? isLoading,
  }) {
    return PopupMenuItem(
      value: value,
      onTap: onTap,
      child: isLoading == true ? _buildLoadingIndicator(text) : Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PollMenuItems>(
      itemBuilder: (context) => [
        if (onAddPoll != null)
          _buildMenuItem(
            value: PollMenuItems.addPoll,
            onTap: onAddPoll,
            text: AppLocalizations.of(context)!.createAPoll,
            isLoading: isOnAddPollLoading,
          ),
        if (onEditPoll != null)
          _buildMenuItem(
            value: PollMenuItems.editPoll,
            onTap: onEditPoll,
            text: AppLocalizations.of(context)!.editPoll,
            isLoading: isOnEditPollLoading,
          ),
        if (onDeletePoll != null)
          _buildMenuItem(
            value: PollMenuItems.deletePoll,
            onTap: onDeletePoll,
            text: AppLocalizations.of(context)!.deletePoll,
            isLoading: isOnDeletePollLoading,
          ),
        if (onClosePoll != null)
          _buildMenuItem(
            value: PollMenuItems.closePoll,
            onTap: onClosePoll,
            text: AppLocalizations.of(context)!.closePoll,
            isLoading: isOnClosePollLoading,
          ),
        if (onSeeClosedPolls != null)
          _buildMenuItem(
            value: PollMenuItems.seeClosedPolls,
            onTap: onSeeClosedPolls,
            text: AppLocalizations.of(context)!.seeClosedPolls,
            isLoading: isOnSeeClosedPollsLoading,
          ),
      ],
    );
  }
}
