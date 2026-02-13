import 'package:flutter/material.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/features/legal/data/legal_section.dart';
import 'package:aurabus/features/legal/widgets/legal_document_header.dart';
import 'package:aurabus/features/legal/widgets/legal_section_card.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final Set<int> _expandedSections = {};

  List<LegalSection> _buildSections(AppLocalizations l10n) {
    return [
      LegalSection(title: l10n.ppIntroTitle, body: l10n.ppIntroBody),
      LegalSection(
        title: l10n.ppDataCollectedTitle,
        body: l10n.ppDataCollectedBody,
      ),
      LegalSection(title: l10n.ppHowWeUseTitle, body: l10n.ppHowWeUseBody),
      LegalSection(
        title: l10n.ppDataSharingTitle,
        body: l10n.ppDataSharingBody,
      ),
      LegalSection(
        title: l10n.ppDataStorageTitle,
        body: l10n.ppDataStorageBody,
      ),
      LegalSection(title: l10n.ppRetentionTitle, body: l10n.ppRetentionBody),
      LegalSection(title: l10n.ppRightsTitle, body: l10n.ppRightsBody),
      LegalSection(title: l10n.ppChildrenTitle, body: l10n.ppChildrenBody),
      LegalSection(title: l10n.ppCookiesTitle, body: l10n.ppCookiesBody),
      LegalSection(title: l10n.ppChangesTitle, body: l10n.ppChangesBody),
      LegalSection(title: l10n.ppContactTitle, body: l10n.ppContactBody),
      LegalSection(title: l10n.ppDpoTitle, body: l10n.ppDpoBody),
    ];
  }

  void _toggleSection(int index) {
    setState(() {
      _expandedSections.contains(index)
          ? _expandedSections.remove(index)
          : _expandedSections.add(index);
    });
  }

  void _toggleAll(int totalSections) {
    setState(() {
      if (_expandedSections.length == totalSections) {
        _expandedSections.clear();
      } else {
        _expandedSections.addAll(
          List.generate(totalSections, (index) => index),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = _buildSections(l10n);
    final allExpanded = _expandedSections.length == sections.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _toggleAll(sections.length),
            icon: Icon(
              allExpanded
                  ? Icons.unfold_less_rounded
                  : Icons.unfold_more_rounded,
              size: 18,
            ),
            label: Text(
              allExpanded ? 'Collapse' : 'Expand',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              FadeInSlide(
                delay: 0.1,
                child: LegalDocumentHeader(
                  icon: Icons.shield_outlined,
                  title: l10n.privacyPolicyTitle,
                  lastUpdated: l10n.lastUpdated('13/02/2026'),
                ),
              ),
              ...List.generate(sections.length, (index) {
                return FadeInSlide(
                  delay: 0.15 + (index * 0.04),
                  child: LegalSectionCard(
                    section: sections[index],
                    isExpanded: _expandedSections.contains(index),
                    onTap: () => _toggleSection(index),
                    index: index,
                  ),
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
