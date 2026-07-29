/// Supabase connection details for the `ali206S207's Project` instance.
///
/// The anon key is a public, RLS-constrained key — it's meant to be
/// embedded in client apps (unlike the service_role key, which must
/// never appear in client code). All Life OS tables are prefixed
/// `lifeos_` and live in the same project as TEFA GYM/Store, in their
/// own tables with owner-only Row Level Security so the two apps never
/// see each other's data.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://ublurrzfsxikexfhqbns.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVibHVycnpmc3hpa2V4ZmhxYm5zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1NDEyODEsImV4cCI6MjA5MzExNzI4MX0.SPlW6T2iBg8tTkFbp1FXDKHaoZrkDlnUAxlUPNhIiFQ';
}
