import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class AIRecommendationsScreen extends StatefulWidget {
  const AIRecommendationsScreen({Key? key}) : super(key: key);

  @override
  State<AIRecommendationsScreen> createState() =>
      _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen> {
  bool _isAnalyzing = false;
  String? _apiKey;

  final List<Map<String, dynamic>> _aiRecommendations = [
    {
      'terminal': 'Kochi North Terminal',
      'risk': 'High',
      'issueType': 'Electrical',
      'confidence': 92,
      'recommendation': 'Upgrade wiring system immediately',
      'factors': [
        'High humidity levels detected',
        'Recent electrical incidents',
        'Aging infrastructure',
        'Frequent power fluctuations',
      ],
    },
    {
      'terminal': 'Kochi South Terminal',
      'risk': 'Medium',
      'issueType': 'Mechanical',
      'confidence': 78,
      'recommendation': 'Check pump maintenance schedule',
      'factors': [
        'Irregular maintenance history',
        'Pump efficiency declining',
        'Corrosion signs detected',
      ],
    },
    {
      'terminal': 'Fort Kochi Terminal',
      'risk': 'Low',
      'issueType': 'Structural',
      'confidence': 65,
      'recommendation': 'Monitor structural integrity quarterly',
      'factors': ['Minor wear and tear', 'Regular maintenance up to date'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text(
          'AI Insights Center',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
        ),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => _showAIHistory(context),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),
            _buildAnalysisButton(),
            const SizedBox(height: 32),
            const Text(
              'Terminal Risk Analysis',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ..._aiRecommendations.map((data) => _buildRecommendationCard(data)),
            const SizedBox(height: 24),
            _buildVisualizationSection(),
            const SizedBox(height: 24),
            _buildExportSection(),
          ],
        ),
      ),
    );
  }

  // HEADER CARD
  Widget _buildHeaderSection() {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.aqua.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.psychology, color: AppColors.aqua, size: 40),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Insights Center',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Data-driven recommendations to improve safety & efficiency',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // RUN ANALYSIS BUTTON
  Widget _buildAnalysisButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isAnalyzing ? null : _runNewAnalysis,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.aqua,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: _isAnalyzing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.auto_awesome, color: Colors.white),
        label: Text(
          _isAnalyzing ? "Analyzing..." : "Run Location Analysis",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // RECOMMENDATION CARD
  Widget _buildRecommendationCard(Map<String, dynamic> data) {
    Color riskColor = _getRiskColor(data['risk']);
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: riskColor.withOpacity(0.3),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetailedReport(context, data),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Terminal & Risk Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data['terminal'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data['risk'],
                      style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Details Row
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      'Issue Type',
                      data['issueType'],
                      Icons.warning_amber,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      'Confidence',
                      '${data['confidence']}%',
                      Icons.show_chart,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recommendation
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.aqua.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: AppColors.aqua, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['recommendation'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _showDetailedReport(context, data),
                  icon: const Icon(Icons.visibility, size: 18, color: AppColors.aqua),
                  label: const Text('View Details',
                      style: TextStyle(color: AppColors.aqua)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.white60),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  // RISK VISUALIZATION
  Widget _buildVisualizationSection() {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Risk Distribution',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRiskIndicator('High', 1, AppColors.red),
                _buildRiskIndicator('Medium', 1, Colors.orange),
                _buildRiskIndicator('Low', 1, AppColors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskIndicator(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  // EXPORT SECTION
  Widget _buildExportSection() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _downloadReport,
            icon: const Icon(Icons.download, color: AppColors.aqua),
            label: const Text('Download PDF',
                style: TextStyle(color: AppColors.aqua)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.aqua),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveToTerminal,
            icon: const Icon(Icons.attachment, color: Colors.white),
            label: const Text('Attach to Terminal',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // COLORS + ACTIONS
  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return AppColors.green;
      case "medium":
        return Colors.orange;
      case "low":
        return AppColors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _runNewAnalysis() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI analysis completed successfully!'),
          backgroundColor: AppColors.green,
        ),
      );
    }
  }

  void _showDetailedReport(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navy.withOpacity(0.98),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(data['terminal'],
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                const Text('Detailed AI Analysis Report',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.help_outline, color: AppColors.yellow),
                          SizedBox(width: 8),
                          Text('Why this prediction?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List<Widget>.from((data['factors'] as List).map(
                        (factor) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '• $factor',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Recommended Actions',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.aqua.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(data['recommendation'],
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 15)),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white70)),
                        child: const Text('Close',
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _downloadReport();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.aqua),
                        child: const Text('Export Report',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAIHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.darkBlue.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('AI Analysis History',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) => ListTile(
                  leading:
                      const Icon(Icons.history, color: AppColors.aqua, size: 22),
                  title: Text(
                    'Analysis ${DateFormat('dd MMM yyyy').format(
                      DateTime.now().subtract(Duration(days: index)),
                    )}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text('Model: Risk Prediction v2.1',
                      style: TextStyle(color: Colors.white70)),
                  trailing: const Icon(Icons.visibility,
                      color: Colors.white54, size: 18),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('Close', style: TextStyle(color: AppColors.aqua)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
