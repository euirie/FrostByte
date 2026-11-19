import 'package:flutter/material.dart';

void main() {
  runApp(const IceTrackApp());
}

class IceTrackApp extends StatelessWidget {
  const IceTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IceTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF16191D),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

// ============================================================================
// SHARED HEADER & DRAWER WIDGETS
// ============================================================================

class _PrototypeHeader extends StatelessWidget {
  final String screenLabel;
  final String title;
  final VoidCallback onLogout;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _PrototypeHeader({
    required this.screenLabel,
    required this.title,
    required this.onLogout,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF2B323C);
    const accentBlue = Color(0xFF53A8FF);
    const logoutRed = Color(0xFFF87171);

    return Column(
      children: [
        // Top Prototype Status Strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                screenLabel,
                style: const TextStyle(
                  color: accentBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
              const Text(
                'IceTrack',
                style: TextStyle(
                  color: Color(0xFF9AA4B2),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
        // App Navigation Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor, width: 1)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu_rounded, color: Color(0xFFCBD5E1)),
                tooltip: 'Quick Screen Switcher',
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181C21),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout_rounded, color: logoutRed, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: logoutRed,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickNavDrawer extends StatelessWidget {
  final String currentScreen;

  const _QuickNavDrawer({required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF181C21),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'IceTrack Prototype',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Quick screen navigation',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
              ),
            ),
            const Divider(color: Color(0xFF2B323C), height: 28),
            ListTile(
              leading: const Icon(Icons.login_rounded, color: Color(0xFF53A8FF)),
              title: const Text('UI-01: Login'),
              selected: currentScreen == 'UI-01',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping_outlined,
                  color: Color(0xFF53A8FF)),
              title: const Text('UI-02: Driver Trip / Load'),
              selected: currentScreen == 'UI-02',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DriverTripScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined,
                  color: Color(0xFF53A8FF)),
              title: const Text('UI-07: Reconciliation Dashboard'),
              selected: currentScreen == 'UI-07',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ReconciliationDashboardScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// UI-01: LOGIN SCREEN (FR-01)
// ============================================================================

enum UserRole { driver, clerk }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController =
      TextEditingController(text: 'driver01');
  final TextEditingController _passwordController =
      TextEditingController(text: 'password1234');

  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.driver;
  String? _errorMessage;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    final staffId = _idController.text.trim();
    final password = _passwordController.text;

    if (staffId.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both Email / Staff ID and Password.';
      });
      return;
    }

    setState(() => _errorMessage = null);

    if (_selectedRole == UserRole.driver) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DriverTripScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const ReconciliationDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF2B323C);
    const primaryBlue = Color(0xFF2166C2);
    const accentBlue = Color(0xFF53A8FF);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor, width: 1)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'UI-01: Login',
                    style: TextStyle(
                      color: accentBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'IceTrack',
                    style: TextStyle(
                      color: Color(0xFF9AA4B2),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFF19222E),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF26384E),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E324A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: accentBlue, width: 1.5),
                          ),
                          child: const Icon(
                            Icons.view_in_ar_rounded,
                            color: accentBlue,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'IceTrack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'IceTrack — Ice Delivery and Payment Management System',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 13.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181C21),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email / Staff ID',
                            style: TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _idController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Staff ID or email',
                              hintStyle:
                                  const TextStyle(color: Color(0xFF64748B)),
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                                color: Color(0xFF94A3B8),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF16191D),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: accentBlue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter password',
                              hintStyle:
                                  const TextStyle(color: Color(0xFF64748B)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF94A3B8),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: const Color(0xFF16191D),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: accentBlue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Sign in as',
                            style: TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _RoleSelectorButton(
                                  label: 'Driver',
                                  isSelected: _selectedRole == UserRole.driver,
                                  onTap: () {
                                    setState(() {
                                      _selectedRole = UserRole.driver;
                                      _idController.text = 'driver01';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _RoleSelectorButton(
                                  label: 'Clerk',
                                  isSelected: _selectedRole == UserRole.clerk,
                                  onTap: () {
                                    setState(() {
                                      _selectedRole = UserRole.clerk;
                                      _idController.text = 'clerk01';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFF87171),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _handleSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.chevron_right_rounded, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181C21),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 12.5),
                          children: [
                            TextSpan(
                              text: 'Role routing: ',
                              style: TextStyle(
                                color: accentBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'Driver → UI-02 · Clerk → UI-07',
                              style: TextStyle(color: Color(0xFFCBD5E1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleSelectorButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleSelectorButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accentBlue = Color(0xFF53A8FF);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A2636)
              : const Color(0xFF16191D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF2B6CB0) : const Color(0xFF2B323C),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_rounded, color: accentBlue, size: 17),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? accentBlue : const Color(0xFFE2E8F0),
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// UI-02: DRIVER TRIP / LOAD SCREEN (FR-03)
// ============================================================================

class DriverTripScreen extends StatefulWidget {
  const DriverTripScreen({super.key});

  @override
  State<DriverTripScreen> createState() => _DriverTripScreenState();
}

class _DriverTripScreenState extends State<DriverTripScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _issuedLoad = 500;
  final int _delivered = 320;
  int _returned = 10;

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _openLogLoadReturnDialog() {
    String movementType = 'Load Out';
    final qtyController = TextEditingController();
    String? dialogError;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final remainingBags = _issuedLoad - _delivered - _returned;

            return AlertDialog(
              backgroundColor: const Color(0xFF181C21),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF2B323C)),
              ),
              title: const Text(
                'Log Load / Return (FR-03)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remaining lorry stock: $remainingBags bags',
                    style: const TextStyle(
                        color: Color(0xFF94A3B8), fontSize: 12.5),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                       initialValue: movementType,
                        dropdownColor: const Color(0xFF181C21),
                    decoration: InputDecoration(
                      labelText: 'Movement Type',
                      filled: true,
                      fillColor: const Color(0xFF16191D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'Load Out', child: Text('Load Out (+ bags)')),
                      DropdownMenuItem(
                          value: 'Return In',
                          child: Text('Return In (Unsold bags)')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          movementType = val;
                          dialogError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Bag Quantity',
                      hintText: 'e.g. 20',
                      filled: true,
                      fillColor: const Color(0xFF16191D),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (dialogError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      dialogError!,
                      style: const TextStyle(
                          color: Color(0xFFF87171), fontSize: 12),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFF94A3B8))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2166C2),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final qty = int.tryParse(qtyController.text.trim()) ?? 0;
                    if (qty <= 0) {
                      setDialogState(
                          () => dialogError = 'Enter a valid bag quantity.');
                      return;
                    }
                    if (movementType == 'Return In' && qty > remainingBags) {
                      setDialogState(() => dialogError =
                          'Return quantity cannot exceed remaining lorry stock ($remainingBags bags).');
                      return;
                    }
                    setState(() {
                      if (movementType == 'Load Out') {
                        _issuedLoad += qty;
                      } else {
                        _returned += qty;
                      }
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF181C21);
    const borderColor = Color(0xFF2B323C);
    const accentBlue = Color(0xFF53A8FF);
    const primaryBlue = Color(0xFF2166C2);
    const logoutRed = Color(0xFFF87171);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const _QuickNavDrawer(currentScreen: 'UI-02'),
      body: SafeArea(
        child: Column(
          children: [
            _PrototypeHeader(
              screenLabel: 'UI-02: Driver Trip / Load',
              title: 'Driver Trip / Load',
              onLogout: _logout,
              scaffoldKey: _scaffoldKey,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Card 1: CURRENT TRIP ID
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'CURRENT TRIP ID',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F2922),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF15803D),
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  'In Progress',
                                  style: TextStyle(
                                    color: Color(0xFF34D399),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'TRP-001',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: accentBlue,
                                size: 17,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Driver 01 · 13 Nov 2026 · Route A',
                                style: TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Card 2: STOCK COUNTER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'STOCK COUNTER',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _StockStatTile(
                                  label: 'Issued Load',
                                  value: '$_issuedLoad',
                                  bgColor: const Color(0xFF1C222B),
                                  borderColor: const Color(0xFF2B323C),
                                  accentColor: const Color(0xFF60A5FA),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _StockStatTile(
                                  label: 'Delivered',
                                  value: '$_delivered',
                                  bgColor: const Color(0xFF0F2922),
                                  borderColor: const Color(0xFF15803D),
                                  accentColor: const Color(0xFF34D399),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _StockStatTile(
                                  label: 'Returned',
                                  value: '$_returned',
                                  bgColor: const Color(0xFF292011),
                                  borderColor: const Color(0xFF854D0E),
                                  accentColor: const Color(0xFFFBBF24),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // Clerk Confirmation Banner
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF292011),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF854D0E),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Clerk Confirmation',
                                  style: TextStyle(
                                    color: Color(0xFFFCD34D),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B2E14),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Pending',
                                    style: TextStyle(
                                      color: Color(0xFFFBBF24),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action 1: + Log Load / Return
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _openLogLoadReturnDialog,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: cardBg,
                          foregroundColor: const Color(0xFF60A5FA),
                          side: const BorderSide(
                              color: Color(0xFF2B6CB0), width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text(
                          'Log Load / Return',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action 2: New Delivery and Invoice
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: primaryBlue,
                              content: Text(
                                'Opening UI-03: Delivery and Invoice (FR-04)...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.receipt_long_outlined, size: 20),
                        label: const Text(
                          'New Delivery and Invoice',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action 3: Logout
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _logout,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: cardBg,
                          foregroundColor: logoutRed,
                          side: const BorderSide(color: borderColor, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 19),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockStatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;
  final Color borderColor;
  final Color accentColor;

  const _StockStatTile({
    required this.label,
    required this.value,
    required this.bgColor,
    required this.borderColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: accentColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'bags',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// UI-07: RECONCILIATION DASHBOARD SCREEN (FR-08 & FR-AI-01)
// ============================================================================

class ReconciliationDashboardScreen extends StatefulWidget {
  const ReconciliationDashboardScreen({super.key});

  @override
  State<ReconciliationDashboardScreen> createState() =>
      _ReconciliationDashboardScreenState();
}

class _ReconciliationDashboardScreenState
    extends State<ReconciliationDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _aiLanguage = 'EN';
  String _aiSummaryText =
      "Request a review to compare today's stock, delivery, and cash records.";

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _generateAiSummary() {
    setState(() {
      if (_aiLanguage == 'EN') {
        _aiSummaryText =
            'Trip TRP-001 recorded 500 bags loaded, 320 bags delivered, and 10 bags returned (170 bags unaccounted/pending). Expected cash is RM 320.00 against RM 310.00 confirmed handover, leaving a -RM 10.00 cash variance for clerk verification.';
      } else {
        _aiSummaryText =
            'Trip TRP-001 merekodkan 500 beg dimuatkan, 320 beg dihantar, dan 10 beg dipulangkan (170 beg belum disahkan). Tunai dijangka ialah RM 320.00 berbanding serahan disahkan RM 310.00, dengan perbezaan tunai -RM 10.00 untuk semakan kerani.';
      }
    });
  }

  void _openModuleNotice(String label, String screenId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2166C2),
        content: Text(
          'Navigating to $screenId: $label...',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF181C21);
    const borderColor = Color(0xFF2B323C);
    const primaryBlue = Color(0xFF2166C2);
    const accentBlue = Color(0xFF60A5FA);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const _QuickNavDrawer(currentScreen: 'UI-07'),
      body: SafeArea(
        child: Column(
          children: [
            _PrototypeHeader(
              screenLabel: 'UI-07: Reconciliation Dashboard',
              title: 'Reconciliation Dashboard',
              onLogout: _logout,
              scaffoldKey: _scaffoldKey,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 2x2 Metric Cards
                    Row(
                      children: [
                        Expanded(
                          child: _DashboardMetricCard(
                            icon: Icons.view_in_ar_outlined,
                            iconColor: accentBlue,
                            label: 'LOADED',
                            value: '500 bags',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardMetricCard(
                            icon: Icons.local_shipping_outlined,
                            iconColor: accentBlue,
                            label: 'DELIVERED',
                            value: '320 bags',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DashboardMetricCard(
                            icon: Icons.assignment_return_outlined,
                            iconColor: const Color(0xFFFBBF24),
                            label: 'RETURNED',
                            value: '10 bags',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardMetricCard(
                            icon: Icons.payments_outlined,
                            iconColor: const Color(0xFF34D399),
                            label: 'EXPECTED CASH',
                            value: 'RM 320.00',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Confirmed Handover & Difference Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Confirmed Handover',
                                style: TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'RM 310.00',
                                style: TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Difference',
                                style: TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'RM 10.00',
                                style: TextStyle(
                                  color: Color(0xFFF87171),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // AI Review Language Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'AI review language',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Row(
                            children: [
                              _LangChip(
                                label: 'EN',
                                isSelected: _aiLanguage == 'EN',
                                onTap: () =>
                                    setState(() => _aiLanguage = 'EN'),
                              ),
                              _LangChip(
                                label: 'BM',
                                isSelected: _aiLanguage == 'BM',
                                onTap: () =>
                                    setState(() => _aiLanguage = 'BM'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Request AI Daily Review Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _generateAiSummary,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.auto_awesome_outlined, size: 19),
                        label: const Text(
                          'Request AI Daily Review',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // AI Summary Output Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome_outlined,
                                  color: accentBlue, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'AI Summary',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _aiSummaryText,
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 13.5,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Read-only AI summary. Verify source records.',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Bottom 2x2 Navigation Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _QuickModuleButton(
                            icon: Icons.people_outline_rounded,
                            label: 'Customers and Terms',
                            onTap: () => _openModuleNotice(
                                'Customers and Terms', 'UI-05'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickModuleButton(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Credit Balances',
                            onTap: () =>
                                _openModuleNotice('Credit Balances', 'UI-06'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickModuleButton(
                            icon: Icons.history_rounded,
                            label: 'Correction History',
                            onTap: () => _openModuleNotice(
                                'Correction History', 'UI-08'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickModuleButton(
                            icon: Icons.description_outlined,
                            label: 'CSV Export',
                            onTap: () =>
                                _openModuleNotice('CSV Export', 'UI-09'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DashboardMetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF181C21),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2B323C), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 19),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2166C2) : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _QuickModuleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickModuleButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF181C21),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2B323C), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF60A5FA), size: 17),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF60A5FA),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}