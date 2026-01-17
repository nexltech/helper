import 'package:flutter/material.dart';

class ConfirmAvailabilityScreen extends StatefulWidget {
  const ConfirmAvailabilityScreen({super.key});

  @override
  State<ConfirmAvailabilityScreen> createState() =>
      _ConfirmAvailabilityScreenState();
}

class _ConfirmAvailabilityScreenState extends State<ConfirmAvailabilityScreen> {
  bool noLongerNeed = true;
  bool foundElsewhere = false;
  bool other = false;
  String otherText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '📍 Confirm Your\nAvailability',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'HomemadeApple',
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "You’ve been approved for this job! Please confirm that you’ll be there so we can finalize the booking.",
                  style: const TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("❓", style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Can you commit to this job?",
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.check_box, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Confirming means the client will expect you at the scheduled time.",
                        style: TextStyle(
                          fontFamily: 'LifeSavers',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select a reason:',
                  style: TextStyle(
                    fontFamily: 'LifeSavers',
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: noLongerNeed,
                  onChanged: (v) => setState(() => noLongerNeed = v!),
                  title: const Text(
                    'I no longer need the service',
                    style: TextStyle(fontFamily: 'LifeSavers', fontSize: 14),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: foundElsewhere,
                  onChanged: (v) => setState(() => foundElsewhere = v!),
                  title: const Text(
                    'I found someone outside Helpr',
                    style: TextStyle(fontFamily: 'LifeSavers', fontSize: 14),
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: other,
                  onChanged: (v) => setState(() => other = v!),
                  title: const Text(
                    'Other:',
                    style: TextStyle(fontFamily: 'LifeSavers', fontSize: 14),
                  ),
                ),
                if (other)
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Write reason...',
                        labelStyle: const TextStyle(
                          color: Colors.black38,
                          fontFamily: 'LifeSavers',
                        ),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => otherText = value,
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  "Need to make changes?\nMessage the client directly or contact support if your plans change.",
                  style: TextStyle(fontFamily: 'LifeSavers', fontSize: 12),
                ),
                const SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        fontFamily: 'LifeSavers',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
