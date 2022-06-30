import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:supabase/supabase.dart';
import 'package:universal_io/io.dart';

class ImageStorageService {
  final client = SupabaseClient('https://biqvzpvabujhigaadwpf.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJpcXZ6cHZhYnVqaGlnYWFkd3BmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTU4OTU3NzgsImV4cCI6MTk3MTQ3MTc3OH0.fK4jLTepM2STv-Stv2SOELQZd5Ard0tSfqxBxbQ4Fto');

  Future<String?> uploadImage(XFile image) async {
    // Create file `example.txt` and upload it in `public` bucket
    final file = File(image.path);
    await client.storage.from('images').upload(image.name, file);

    // Get download url
    final urlResponse = await client.storage
        .from('images')
        .createSignedUrl(basename(image.path), 60);
    print(urlResponse);
    return urlResponse.data;
  }
}
