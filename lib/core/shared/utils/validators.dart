String? validarPesoBF(String? v, {double min = 20, double max = 500}) {
  final s = (v ?? '').trim();
  if (s.isEmpty) return null; // opcional
  final re = RegExp(r'^\d{1,3}(,\d{1,2})?$'); // ex: 65,7 | 65,70 | 65
  if (!re.hasMatch(s)) return 'Peso inválido';
  final n = double.tryParse(s.replaceAll('.', '').replaceAll(',', '.'));
  if (n == null) return 'Peso inválido';
  if (n < min || n > max)
    return 'Peso deve estar entre ${min.toStringAsFixed(1)} e ${max.toStringAsFixed(1)}';
  return null;
}

String? validarAlturaBF(String? v, {double min = 0.5, double max = 2.5}) {
  final s = (v ?? '').trim();
  if (s.isEmpty) return null; // opcional
  final re = RegExp(r'^\d{1}(,\d{1,2})?$'); // ex: 1,69 | 1,7 | 2 | 1,70
  if (!re.hasMatch(s)) return 'Altura inválida';
  final n = double.tryParse(s.replaceAll('.', '').replaceAll(',', '.'));
  if (n == null) return 'Altura inválida';
  if (n < min || n > max)
    return 'Altura deve estar entre ${min.toStringAsFixed(2)} e ${max.toStringAsFixed(2)}';
  return null;
}
