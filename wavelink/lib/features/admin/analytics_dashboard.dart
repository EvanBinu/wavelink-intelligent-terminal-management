import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboardScreen> {
  String _selectedTimeFilter = 'Monthly';
  String _selectedTerminal = 'All Terminals';

  final List<String> _timeFilters = ['Weekly', 'Monthly', 'Yearly'];
  final List<String> _terminals = [
    'All Terminals',
    'Kochi North Terminal',
    'Kochi South Terminal',
    'Fort Kochi Terminal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text(
          'Analytics Dashboard',
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
            icon: const Icon(Icons.file_download, color: Colors.white),
            onPressed: _showExportDialog,
            tooltip: 'Export Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Operational Analytics & Reports',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data-driven insights for operational efficiency',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 24),

            _buildFiltersSection(),
            const SizedBox(height: 24),

            _buildKPISummaryRow(),
            const SizedBox(height: 32),

            const Text(
              'Performance Metrics',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),

            _buildChartCard(
                'Repairs Overview', 'Completed vs Pending per Terminal',
                Icons.bar_chart, AppColors.aqua, 'bar'),
            _buildChartCard(
                'Accident Trends', 'Incident reports over time',
                Icons.show_chart, AppColors.red, 'line'),
            _buildChartCard(
                'Certificate Status', 'Active vs Expired Certificates',
                Icons.pie_chart, AppColors.green, 'pie'),
            _buildChartCard(
                'Terminal Risk Profile', 'Safety, Finance & Maintenance',
                Icons.radar, Colors.purple, 'radar'),

            const SizedBox(height: 32),

            const Text(
              'Detailed Reports',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),

            _buildReportCard('Maintenance Reports',
                'Cost analysis, frequency & downtime metrics',
                Icons.build, AppColors.aqua),
            _buildReportCard('Finance Reports',
                'Budget utilization & expense anomalies',
                Icons.account_balance_wallet, Colors.green),
            _buildReportCard('Compliance Reports',
                'Certificate status & audit readiness',
                Icons.verified_user, Colors.orange),

            const SizedBox(height: 32),
            _buildAIPredictionCard(),
            const SizedBox(height: 24),
            _buildExportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: AppColors.aqua.withOpacity(0.3),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.filter_list, color: AppColors.aqua, size: 20),
                SizedBox(width: 8),
                Text('Filters & Controls',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildDropdown(
                        'Time Period', _timeFilters, _selectedTimeFilter,
                        (val) => setState(() => _selectedTimeFilter = val!))),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildDropdown(
                        'Terminal', _terminals, _selectedTerminal,
                        (val) => setState(() => _selectedTerminal = val!))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: AppColors.navy,
              value: value,
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white70,
              items: items
                  .map((val) =>
                      DropdownMenuItem(value: val, child: Text(val)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKPISummaryRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Key Performance Indicators',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildKPICard('Active Terminals', '12', Icons.business,
                AppColors.aqua, '+2 this month'),
            _buildKPICard('Incidents', '8', Icons.warning, AppColors.red,
                '-3 from last month'),
            _buildKPICard('Tasks Completed', '156', Icons.check_circle,
                AppColors.green, '94% completion rate'),
            _buildKPICard('Compliance', '87%', Icons.verified, Colors.orange,
                'Certificate status'),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: color.withOpacity(0.3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Icon(icon, color: color, size: 24),
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 18))
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.white60, fontSize: 11))
              ])
            ]),
      ),
    );
  }

  Widget _buildChartCard(String title, String subtitle, IconData icon,
      Color color, String chartType) {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: color.withOpacity(0.3),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showChartDetails(title, chartType),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 28)),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(subtitle,
                        style:
                            const TextStyle(color: Colors.white70, fontSize: 13))
                  ]))
            ]),
            const SizedBox(height: 20),
            Container(
                height: 180,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Icon(icon, size: 60, color: color.withOpacity(0.4))))
          ]),
        ),
      ),
    );
  }

  Widget _buildReportCard(
      String title, String subtitle, IconData icon, Color color) {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: color.withOpacity(0.3),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
        onTap: () => _openReport(title),
      ),
    );
  }

  Widget _buildAIPredictionCard() {
    return Card(
      color: Colors.purple.withOpacity(0.15),
      shadowColor: Colors.purpleAccent,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.psychology, color: Colors.purple, size: 28),
            SizedBox(width: 12),
            Text('AI Predictions',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))
          ]),
          const SizedBox(height: 16),
          const Text('Predicted Risk Next Month: 12 incidents (±2)',
              style: TextStyle(color: Colors.white70)),
          const Text('Current: 8 incidents',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Opening AI Insights Center...'),
                    duration: Duration(seconds: 1)));
              },
              icon: const Icon(Icons.visibility, color: Colors.purple),
              label: const Text('View Full AI Analysis',
                  style: TextStyle(color: Colors.purple)))
        ]),
      ),
    );
  }

  Widget _buildExportSection() {
    return Row(children: [
      Expanded(
          child: OutlinedButton.icon(
              onPressed: () => _exportReport('PDF'),
              icon: const Icon(Icons.picture_as_pdf, color: AppColors.aqua),
              label: const Text('Export as PDF',
                  style: TextStyle(color: AppColors.aqua)),
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.aqua)))),
      const SizedBox(width: 12),
      Expanded(
          child: ElevatedButton.icon(
              onPressed: () => _exportReport('CSV'),
              icon: const Icon(Icons.table_chart, color: Colors.white),
              label: const Text('Export as CSV',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.aqua)))
    ]);
  }

  void _showChartDetails(String title, String chartType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navy.withOpacity(0.95),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title,
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Detailed ${chartType.toUpperCase()} chart',
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                  child: Text('Chart visualization here',
                      style: TextStyle(color: Colors.white60)))),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.aqua),
              child:
                  const Text('Close', style: TextStyle(color: Colors.white)))
        ]),
      ),
    );
  }

  void _openReport(String reportType) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opening $reportType...'),
        duration: const Duration(seconds: 1)));
  }

  void _showExportDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: AppColors.darkBlue,
              title: const Text('Export Report',
                  style: TextStyle(color: Colors.white)),
              content: const Text(
                  'Select export format for the complete analytics report:',
                  style: TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                        const Text('Cancel', style: TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _exportReport('PDF');
                    },
                    child:
                        const Text('PDF', style: TextStyle(color: AppColors.aqua))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _exportReport('CSV');
                    },
                    child:
                        const Text('CSV', style: TextStyle(color: AppColors.green)))
              ],
            ));
  }

  void _exportReport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exporting report as $format...'),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 2)));
  }
}
