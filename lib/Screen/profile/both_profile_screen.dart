import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_pending_review_screen.dart';
import '../../services/profile_api_service.dart';

class BothProfileScreen extends StatefulWidget {
  const BothProfileScreen({super.key});

  @override
  State<BothProfileScreen> createState() => _BothProfileScreenState();
}

class _BothProfileScreenState extends State<BothProfileScreen> {
  // Eligibility toggles
  final Map<String, bool?> eligibility = {
    'Are you at least 18 years old?': null,
    'Are you authorized to work in the US?': null,
    'Do you consent to a background check?': null,
    'Do you have any criminal convictions?': null,
    'Do you have reliable transportation?': null,
  };

  File? _photoIdFile;
  File? _resumeFile;
  File? _certificationFile;
  File? _portfolioFile;
  
  // Form controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _pickPhotoId() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoIdFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickResume() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _resumeFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCertification() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _certificationFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPortfolio() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _portfolioFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    // Validate form
    if (_fullNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _bioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate eligibility questions
    for (var entry in eligibility.entries) {
      if (entry.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please answer: ${entry.key}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ProfileApiService.registerBothHelp(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        location: _locationController.text.trim(),
        bio: _bioController.text.trim(),
        is18OrOlder: eligibility['Are you at least 18 years old?']!,
        authorizedToWork: eligibility['Are you authorized to work in the US?']!,
        consentBackgroundCheck: eligibility['Do you consent to a background check?']!,
        criminalConvictions: eligibility['Do you have any criminal convictions?']!,
        reliableTransportation: eligibility['Do you have reliable transportation?']!,
        resume: _resumeFile,
        certification: _certificationFile,
        portfolio: _portfolioFile,
        idCardPhoto: _photoIdFile,
      );

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Profile submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProfilePendingReviewScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Profile',
                    style: const TextStyle(
                      fontFamily: 'HomemadeApple',
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 48,
                        backgroundImage: AssetImage(
                            'assets/images/profile_placeholder.png'), // Placeholder
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt,
                              size: 18, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Lexi L.',
                  style: const TextStyle(
                    fontFamily: 'HomemadeApple',
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _sectionTitle('Basic Information'),
              const SizedBox(height: 8),
              _buildTextField('Full Name', _fullNameController,
                  prefixIconPath: 'assets/Icons/name.png'),
              const SizedBox(height: 10),
              _buildTextField('Email Address', _emailController,
                  prefixIconPath: 'assets/Icons/Email.png'),
              const SizedBox(height: 10),
              _buildTextField('Location', _locationController,
                  prefixIconPath: 'assets/Icons/Location.png'),
              const SizedBox(height: 10),
              _buildTextField('Bio / About You', _bioController,
                  prefixIconPath: 'assets/Icons/Bio.png', maxLines: 3),
              const SizedBox(height: 18),
              _sectionTitle('Eligibility'),
              const SizedBox(height: 8),
              ...eligibility.keys
                  .map((q) => _buildEligibilityToggle(q))
                  ,
              const SizedBox(height: 18),
              _sectionTitle('Skills, Services & Experience'),
              const SizedBox(height: 8),
              _buildFileField('Resume', _resumeFile, _pickResume,
                  prefixIconPath: 'assets/Icons/Bio.png',
                  suffixIconPath: 'assets/Icons/erification on trail.png'),
              const SizedBox(height: 10),
              _buildFileField('Certifications or Licenses', _certificationFile, _pickCertification,
                  prefixIconPath: 'assets/Icons/Certificate.png',
                  suffixIconPath: 'assets/Icons/erification on trail.png'),
              const SizedBox(height: 10),
              _buildFileField('Portfolio / Work Samples', _portfolioFile, _pickPortfolio,
                  prefixIconPath: 'assets/Icons/Portfolio.png',
                  suffixIconPath: 'assets/Icons/erification on trail.png'),
              const SizedBox(height: 18),
              _sectionTitle('Verification'),
              const SizedBox(height: 8),
              _buildPhotoIdField(),
              const SizedBox(height: 10),
              // _buildTextField(
              //     'Emergency Contact - Name', Icons.contact_phone_outlined),
              // const SizedBox(height: 10),
              // _buildTextField(
              //     'Emergency Contact - Phone', Icons.phone_outlined),
              // const SizedBox(height: 18),
              Center(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _submitProfile,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(180, 44),
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text('Submit',
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'BioRhyme',
        fontSize: 18,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller,
      {int maxLines = 1, String? prefixIconPath, String? suffixIconPath}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIconPath != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(prefixIconPath, width: 24, height: 24),
              )
            : null,
        suffixIcon: suffixIconPath != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(suffixIconPath, width: 24, height: 24),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle:
            const TextStyle(color: Colors.black38, fontFamily: 'LifeSavers'),
      ),
    );
  }

  Widget _buildFileField(String label, File? file, VoidCallback onTap,
      {String? prefixIconPath, String? suffixIconPath}) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontFamily: 'LifeSavers',
        ),
        prefixIcon: prefixIconPath != null
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(prefixIconPath, width: 24, height: 24),
              )
            : null,
        suffixIcon: suffixIconPath != null
            ? IconButton(
                icon: Image.asset(suffixIconPath, width: 24, height: 24),
                onPressed: onTap,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildEligibilityToggle(String question) {
    final selected = eligibility[question];
    String iconPath;
    if (question == 'Are you at least 18 years old?') {
      iconPath = 'assets/Icons/Age.png';
    } else if (question == 'Are you authorized to work in the US?') {
      iconPath = 'assets/Icons/Location.png';
    } else if (question == 'Do you consent to a background check?') {
      iconPath = 'assets/Icons/BackgroundCheck.png';
    } else if (question == 'Do you have any criminal convictions?') {
      iconPath = 'assets/Icons/CriminalConvictions.png';
    } else if (question == 'Do you have reliable transportation?') {
      iconPath = 'assets/Icons/Location.png';
    } else {
      iconPath = '';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(iconPath, width: 20, height: 20),
                ),
              Text(
                question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontFamily: 'LifeSavers',
                  letterSpacing: 1.5,
                  wordSpacing: 4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ToggleButtons(
              isSelected: [selected == true, selected == false],
              onPressed: (index) {
                setState(() {
                  eligibility[question] = index == 0;
                });
              },
              borderRadius: BorderRadius.circular(28),
              selectedColor: Colors.white,
              fillColor: Colors.black,
              color: Colors.black,
              constraints: const BoxConstraints(minWidth: 150, minHeight: 44),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: selected == true ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'LifeSavers',
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: selected == false ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'LifeSavers',
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Upload a valid photo ID',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset('assets/Icons/Verfication....on lead.png',
                  width: 24, height: 24),
            ),
            suffixIcon: IconButton(
              icon: Image.asset('assets/Icons/erification on trail.png',
                  width: 24, height: 24),
              onPressed: _pickPhotoId,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Colors.black26),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Colors.black),
            ),
            labelStyle: const TextStyle(
                color: Colors.black38, fontFamily: 'LifeSavers'),
          ),
        ),
        if (_photoIdFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _photoIdFile!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Photo ID selected',
                    style: TextStyle(fontFamily: 'LifeSavers')),
              ],
            ),
          ),
      ],
    );
  }
}
