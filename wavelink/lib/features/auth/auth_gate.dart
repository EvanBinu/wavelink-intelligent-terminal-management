import 'package:flutter/material.dart';
import 'package:wavelink/features/auth/login_screen.dart';
import 'package:wavelink/features/admin/admin_dashboard.dart';


class AuthGate extends StatelessWidget {
    const AuthGate({super.key});

    @override
    Widget build(BuildContext context) {
        return StreamBuilder<User?>(
            stream: Supabase.instance.client.auth.onAuthStateChange,
            builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }
                final session = snapshot.data?.session;
                if (session != null) {
                    return const AdminDashboardScreen();
                }       
                else{
                    return const LoginScreen();
                }         
            },
        );
    }
}