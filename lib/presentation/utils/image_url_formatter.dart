String formatImageUrl(String path) {
  if (path.startsWith('http')) {
    return path;
  }
  return 'https://karyana-apis-backend.vercel.app/$path';
}
