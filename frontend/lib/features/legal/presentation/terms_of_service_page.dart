import 'package:flutter/material.dart';
import 'package:aurabus/l10n/app_localizations.dart';
import 'package:aurabus/features/legal/data/legal_section.dart';
import 'package:aurabus/features/legal/widgets/legal_document_header.dart';
import 'package:aurabus/features/legal/widgets/legal_section_card.dart';
import 'package:aurabus/common/widgets/fade_in_slide.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  final Set<int> _expandedSections = {};

  List<LegalSection> _buildSections(AppLocalizations l10n) {
    return [
      LegalSection(title: l10n.tosIntroTitle, body: l10n.tosIntroBody),
      LegalSection(
        title: l10n.tosEligibilityTitle,
        body: l10n.tosEligibilityBody,
      ),
      LegalSection(title: l10n.tosAccountTitle, body: l10n.tosAccountBody),
      LegalSection(title: l10n.tosServiceTitle, body: l10n.tosServiceBody),
      LegalSection(title: l10n.tosUseTitle, body: l10n.tosUseBody),
      LegalSection(title: l10n.tosIpTitle, body: l10n.tosIpBody),
      LegalSection(title: l10n.tosTicketsTitle, body: l10n.tosTicketsBody),
      LegalSection(
        title: l10n.tosDisclaimerTitle,
        body: l10n.tosDisclaimerBody,
      ),
      LegalSection(title: l10n.tosLiabilityTitle, body: l10n.tosLiabilityBody),
      LegalSection(
        title: l10n.tosTerminationTitle,
        body: l10n.tosTerminationBody,
      ),
      LegalSection(title: l10n.tosChangesTitle, body: l10n.tosChangesBody),
      LegalSection(title: l10n.tosGoverningTitle, body: l10n.tosGoverningBody),
      LegalSection(title: l10n.tosContactTitle, body: l10n.tosContactBody),
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
              allExpanded ? l10n.collapseAllLabel : l10n.expandAllLabel,
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
                  icon: Icons.description_outlined,
                  title: l10n.termsOfServiceTitle,
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
