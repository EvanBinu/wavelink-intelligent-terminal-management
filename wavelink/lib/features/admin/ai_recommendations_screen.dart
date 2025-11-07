import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:intl/intl.dart'; // For date formatting

class AIRecommendationsScreen extends StatefulWidget {
  const AIRecommendationsScreen({Key? key}) : super(key: key);

  @override
  State<AIRecommendationsScreen> createState() =>
      _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen> {
  bool _isAnalyzing = false;

  // Sample AI recommendations data
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
      appBar: AppBar(
        title: const Text('AI Insights Center'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showAIHistory(context),
            tooltip: 'AI History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header & Overview Section
            _buildHeaderSection(),
            const SizedBox(height: 24),

            // Run New Analysis Button
            _buildAnalysisButton(),
            const SizedBox(height: 32),

            // AI Insights Title
            const Text(
              'Terminal Risk Analysis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),

            // AI Recommendations Table/Cards
            ..._aiRecommendations.map((data) => _buildRecommendationCard(data)),

            const SizedBox(height: 24),

            // Visualization Section
            _buildVisualizationSection(),

            const SizedBox(height: 24),

            // Export Options
            _buildExportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 4,
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
              child: const Icon(
                Icons.psychology,
                color: AppColors.aqua,
                size: 40,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Insights Center',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Data-driven recommendations to improve safety and efficiency',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isAnalyzing ? null : _runNewAnalysis,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.aqua,
          disabledBackgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon:
            _isAnalyzing
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
          _isAnalyzing ? 'Analyzing...' : 'Run New AI Analysis',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> data) {
    Color riskColor = _getRiskColor(data['risk']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showDetailedReport(context, data),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data['terminal'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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

              // Details Grid
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
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['recommendation'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // View Details Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _showDetailedReport(context, data),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View Details'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.aqua),
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
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildVisualizationSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildExportSection() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _downloadReport,
            icon: const Icon(Icons.download),
            label: const Text('Download PDF'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.navy),
              foregroundColor: AppColors.navy,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveToTerminal,
            icon: const Icon(Icons.attachment, color: Colors.white),
            label: const Text(
              'Attach to Terminal',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return AppColors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _runNewAnalysis() async {
    setState(() => _isAnalyzing = true);

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI analysis completed successfully!'),
          backgroundColor: AppColors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDetailedReport(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder:
                (context, scrollController) => SingleChildScrollView(
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
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data['terminal'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Detailed AI Analysis Report',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),

                      // Why this prediction section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.help_outline, color: Colors.amber),
                                SizedBox(width: 8),
                                Text(
                                  'Why this prediction?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...List<Widget>.from(
                              (data['factors'] as List).map(
                                (factor) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '• ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Text(
                                          factor,
                                          style: const TextStyle(fontSize: 14),
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
                      const SizedBox(height: 24),

                      // Recommended Actions
                      const Text(
                        'Recommended Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data['recommendation'],
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
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
                                backgroundColor: AppColors.aqua,
                              ),
                              child: const Text(
                                'Export Report',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showAIHistory(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('AI Analysis History'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder:
                    (context, index) => ListTile(
                      leading: const Icon(Icons.history, color: AppColors.aqua),
                      title: Text(
                        'Analysis ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}',
                      ),
                      subtitle: const Text('Model: Risk Prediction v2.1'),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility, size: 20),
                        onPressed: () {},
                      ),
                    ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading AI report as PDF...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveToTerminal() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Attach Report'),
            content: const Text('Select terminal to attach this AI report:'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Report attached to terminal successfully!',
                      ),
                      backgroundColor: AppColors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.aqua,
                ),
                child: const Text(
                  'Attach',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
