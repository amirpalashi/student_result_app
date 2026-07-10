class ImportResultModel {
  final int totalRows;
  final int importedRows;
  final int skippedRows;

  final List<String> errors;

  const ImportResultModel({
    required this.totalRows,
    required this.importedRows,
    required this.skippedRows,
    required this.errors,
  });

  bool get hasError => errors.isNotEmpty;
}