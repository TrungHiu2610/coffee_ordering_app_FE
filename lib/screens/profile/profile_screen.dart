import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/providers/auth_provider.dart';
import 'package:flutter_coffee_shop_app/screens/review/review_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _buildLoyaltyBenefitCard({
    required String title,
    required int points,
    required double currentPoints,
    required IconData icon,
  }) {
    final bool isUnlocked = currentPoints >= points;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isUnlocked ? Colors.green.shade50 : Colors.grey.shade100,
      child: ListTile(
        leading: Icon(
          icon,
          color: isUnlocked ? Colors.green : Colors.grey,
          size: 32,
        ),
        title: Text(title),
        subtitle: Text('$points điểm'),
        trailing: isUnlocked 
          ? const Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.lock, color: Colors.grey.shade400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang cá nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (auth.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    auth.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthProvider>().checkAuthState();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final user = auth.currentUser;
          if (user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
            return const SizedBox.shrink();
          }          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('Tên'),
                  subtitle: Text(user.name),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Email'),
                  subtitle: Text(user.email),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Điểm tích lũy'),
                  subtitle: Text('${user.totalPoints.toStringAsFixed(0)} điểm'),
                  trailing: const Icon(Icons.card_giftcard),
                ),
              ),
              if (user.role == 'Staff') 
                Card(
                  color: Colors.cyan.shade50,
                  child: const ListTile(
                    title: Text('Vai trò'),
                    subtitle: Text('Nhân viên'),
                    trailing: Icon(Icons.badge),
                  ),
                ),
              const SizedBox(height: 20),
              
              // Section for benefits from loyalty points
              const Text(
                'Ưu đãi từ điểm tích lũy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildLoyaltyBenefitCard(
                title: 'Giảm 10% hóa đơn',
                points: 100,
                currentPoints: user.totalPoints,
                icon: Icons.discount,
              ),
              _buildLoyaltyBenefitCard(
                title: 'Một ly nước miễn phí',
                points: 200,
                currentPoints: user.totalPoints,
                icon: Icons.free_breakfast,
              ),
              _buildLoyaltyBenefitCard(
                title: 'Thẻ thành viên Bạc',
                points: 500,
                currentPoints: user.totalPoints,
                icon: Icons.card_membership,
              ),
              _buildLoyaltyBenefitCard(
                title: 'Thẻ thành viên Vàng',
                points: 1000,
                currentPoints: user.totalPoints,
                icon: Icons.workspace_premium,
              ),
              
              // Section for my reviews
              const SizedBox(height: 20),
              const Text(
                'Đánh giá của tôi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReviewScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.rate_review, size: 32, color: Colors.amber),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Xem tất cả đánh giá',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Xem lại và chỉnh sửa các đánh giá bạn đã gửi',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}