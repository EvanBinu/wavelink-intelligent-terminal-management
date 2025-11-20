import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class AIRecommendationsScreen extends StatefulWidget {
  const AIRecommendationsScreen({Key? key}) : super(key: key);

  @override
  State<AIRecommendationsScreen> createState() =>
      _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen> {
  bool _isAnalyzing = false;

  final TextEditingController _locationController = TextEditingController();

  List<Map<String, dynamic>> _aiRecommendations = [];

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  // ============================================================
  // 📌 LOAD GEMINI API KEY
  // ============================================================
  Future<void> _loadApiKey() async {
    setState(() {
      _apiKey = "AIzaSyALl4do2PDyIdYD774_f7ogHXgtNPevfAo".trim();
    });
  }

  // ============================================================
  // 📌 RUN ANALYSIS
  // ============================================================
  Future<void> _runNewAnalysis() async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gemini API key missing!"),
          backgroundColor: AppColors.red));
      return;
    }

    final location = _locationController.text.trim();
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter a location"),
          backgroundColor: AppColors.red));
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final model = GenerativeModel(
        model: "gemini-2.5-flash",
        apiKey: _apiKey!,
      );

      final prompt = '''
Analyze the following location for suitability as a new Water Metro terminal:

"$location"

Return ONLY a JSON object in this exact structure:

{
  "location": string,
  "suitability": "High" | "Medium" | "Low",
  "pros": [ "point1", "point2", "point3", ... ],
  "cons": [ "point1", "point2", "point3", ... ],
  "finalRecommendation": string
}

STRICT RULES:
- Return VALID JSON ONLY.
- DO NOT include markdown, code fences, or explanations.
- DO NOT add backticks.
''';

      final response = await model.generateContent([Content.text(prompt)]);

      final raw = response.text?.trim() ?? "";

      // remove unwanted formatting
      final clean = raw
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();

      final decoded = jsonDecode(clean);

      if (decoded is Map<String, dynamic>) {
        setState(() => _aiRecommendations = [decoded]);
      } else {
        throw "Invalid JSON structure returned.";
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Location analysis completed!"),
          backgroundColor: AppColors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("AI failed: $e"), backgroundColor: AppColors.red));
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  // ============================================================
  // 📌 UI START
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title:
            const Text('AI Insights Center', style: TextStyle(color: Colors.white)),
        flexibleSpace:
            Container(decoration: const BoxDecoration(gradient: AppColors.headerGradient)),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
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
            _buildHeaderSection(),
            const SizedBox(height: 24),

            // LOCATION INPUT
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Enter Location (e.g., Aluva)",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: AppColors.navy.withOpacity(0.4),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),
            _buildAnalysisButton(),
            const SizedBox(height: 32),

            const Text(
              "Location Evaluation",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            if (_isAnalyzing)
              const Center(
                child: CircularProgressIndicator(color: AppColors.aqua),
              )
            else if (_aiRecommendations.isEmpty)
              const Text(
                "Enter a location and run analysis.",
                style: TextStyle(color: Colors.white70),
              )
            else
              ..._aiRecommendations.map(_buildRecommendationCard),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 📌 HEADER CARD
  // ============================================================
  Widget _buildHeaderSection() {
    return Card(
      color: AppColors.navy.withOpacity(0.4),
      elevation: 6,
      shadowColor: AppColors.aqua.withOpacity(0.4),
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
              child: const Icon(Icons.psychology,
                  color: AppColors.aqua, size: 40),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "AI Insights Center\nLocation suitability analysis",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 📌 BUTTON
  // ============================================================
  Widget _buildAnalysisButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isAnalyzing ? null : _runNewAnalysis,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.aqua,
          disabledBackgroundColor: Colors.grey[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 6,
          shadowColor: AppColors.aqua.withOpacity(0.3),
        ),
        icon: _isAnalyzing
            ? const CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2)
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

  // ============================================================
  // 📌 RESULT CARD
  // ============================================================
  Widget _buildRecommendationCard(Map<String, dynamic> data) {
    final Color color = _getRiskColor(data["suitability"]);

    return Card(
      color: AppColors.navy.withOpacity(0.4),
      shadowColor: AppColors.aqua.withOpacity(0.4),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data["location"],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Suitability: ${data['suitability']}",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Pros:",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            ...List<Widget>.from((data["pros"] as List)
                .map((p) => Text("• $p",
                    style: const TextStyle(color: Colors.white54)))),

            const SizedBox(height: 16),

            const Text("Cons:",
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            ...List<Widget>.from((data["cons"] as List)
                .map((c) => Text("• $c",
                    style: const TextStyle(color: Colors.white54)))),

            const SizedBox(height: 20),

            Text(data["finalRecommendation"],
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 📌 COLOR HELPER
  // ============================================================
  Color _getRiskColor(String suitability) {
    switch (suitability.toLowerCase()) {
      case "high":
        return AppColors.green;
      default:
        return Colors.grey;
    }
  }

  // ============================================================
  // 📌 HISTORY DIALOG
  // ============================================================
  void _showAIHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.darkBlue.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("AI Analysis History",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 10),

                ...List.generate(
                  3,
                  (i) => ListTile(
                    leading:
                        const Icon(Icons.history, color: AppColors.aqua),
                    title: Text(
                        "Analysis ${DateFormat('dd MMM').format(
                          DateTime.now().subtract(Duration(days: i)),
                        )}",
                        style: const TextStyle(color: Colors.white)),
                    subtitle: const Text("Model: Gemini 2.5 Flash",
                        style: TextStyle(color: Colors.white70)),
                  ),
                ),

                const SizedBox(height: 12),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close",
                        style: TextStyle(color: AppColors.aqua))),
              ]),
        ),
      ),
    );
  }

  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading AI report as PDF...'),
        backgroundColor: AppColors.aqua,
      ),
    );
  }

  void _saveToTerminal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report attached to terminal successfully!'),
        backgroundColor: AppColors.green,
      ),
    );
  }
}
