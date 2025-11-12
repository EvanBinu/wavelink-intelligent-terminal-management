import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
    final SupabaseClient _supabase = Supabase.instance.client;

    Future<AuthResponse> signInWithEmail(String email, String password) async {
        try {
            final response = await _supabase.auth.signInWithPassword(
                email: email,
                password: password,
            );
            return response;
        } catch (error) {
            throw error;
        }
    }
    
    Future<AuthResponse> signUpWithEmail(String email, String password) async {
        try {
            final response = await _supabase.auth.signUp(
                email: email,
                password: password,
            );
            return response;
        } catch (error) {
            throw error;
        }
    }

    Future<void> signOut() async {
        await _supabase.auth.signOut();
    }



    String? getCurrentUserEmail() {
        return _supabase.auth.currentUser?.email;
    }
    

     
}