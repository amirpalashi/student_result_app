import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/result_summary_model.dart';
import '../../models/student_model.dart';
import '../../models/subject_result_model.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/school_settings_model.dart';
import '../school_settings_service.dart';

class MarksheetPdfService {
  const MarksheetPdfService._();

  static Future<Uint8List> generate({
    required StudentModel student,
    required List<SubjectResultModel> results,
    required ResultSummaryModel summary,
  }) async {
    final pdf = pw.Document();
    final settings = await SchoolSettingsService.instance.getSettings();
    pw.MemoryImage? logo;

    if (settings?.logoPath != null && settings!.logoPath!.isNotEmpty) {
      final file = File(settings.logoPath!);

      if (await file.exists()) {
        logo = pw.MemoryImage(await file.readAsBytes());
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(settings, logo),
              pw.SizedBox(height: 20),
              _buildStudentInfo(student),
              pw.SizedBox(height: 20),
              _buildResultBanner(summary),
              pw.SizedBox(height: 20),
              _buildSubjectTable(results),
              pw.SizedBox(height: 20),
              _buildSummary(summary),
              pw.Spacer(),
              _buildSignature(settings),
              pw.SizedBox(height: 20),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> share({
    required StudentModel student,
    required List<SubjectResultModel> results,
    required ResultSummaryModel summary,
  }) async {
    final file = await save(
      student: student,
      results: results,
      summary: summary,
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Marksheet - ${student.studentName}',
      ),
    );
  }

  static Future<File> save({
    required StudentModel student,
    required List<SubjectResultModel> results,
    required ResultSummaryModel summary,
  }) async {
    final pdfBytes = await generate(
      student: student,
      results: results,
      summary: summary,
    );

    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/${student.studentId}_marksheet.pdf');

    await file.writeAsBytes(pdfBytes);

    return file;
  }

  static Future<void> print({
    required StudentModel student,
    required List<SubjectResultModel> results,
    required ResultSummaryModel summary,
  }) async {
    await Printing.layoutPdf(
      onLayout: (format) async {
        return generate(student: student, results: results, summary: summary);
      },
    );
  }

  static pw.Widget _buildHeader(
    SchoolSettingsModel? settings,
    pw.MemoryImage? logo,
  ) {
    return pw.Column(
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(border: pw.Border.all(width: .8)),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Logo
              if (logo != null)
                pw.Container(
                  width: 70,
                  height: 70,
                  child: pw.Image(logo, fit: pw.BoxFit.contain),
                )
              else
                pw.Container(
                  width: 70,
                  height: 70,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: .5),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      "LOGO",
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                ),

              pw.SizedBox(width: 15),

              // School Information
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      settings?.organizationName.isNotEmpty == true
                          ? settings!.organizationName
                          : "School Name",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                    if (settings != null && settings.address.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 4),
                        child: pw.Text(
                          settings.address,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),

                    if (settings != null && settings.eiin.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2),
                        child: pw.Text(
                          "EIIN : ${settings.eiin}",
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 10),

        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            border: pw.Border.all(width: .8),
          ),
          child: pw.Center(
            child: pw.Text(
              "ACADEMIC TRANSCRIPT",
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildStudentInfo(StudentModel student) {
    pw.Widget item(String title, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 70,
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                value.isEmpty ? "-" : value,
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      );
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: .8)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "STUDENT INFORMATION",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
          ),

          pw.SizedBox(height: 10),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  children: [
                    item("Student ID", student.studentId),
                    item("Name", student.studentName),
                    item("Roll", student.roll),
                    item("Class", student.className),
                  ],
                ),
              ),

              pw.SizedBox(width: 25),

              pw.Expanded(
                child: pw.Column(
                  children: [
                    item("Father", student.fatherName),
                    item("Session", student.session),
                    item("Exam", student.exam),
                    item("Group", student.groupName),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSubjectTable(List<SubjectResultModel> results) {
    return pw.Table(
      border: pw.TableBorder.all(width: .8),
      columnWidths: {
        0: const pw.FlexColumnWidth(5),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          children: [
            _tableHeader('Subject'),
            _tableHeader('Marks'),
            _tableHeader('Grade'),
          ],
        ),

        ...results.map(
          (subject) => pw.TableRow(
            children: [
              _tableCell(subject.subjectName),
              _tableCell(subject.marks.toString(), align: pw.TextAlign.center),
              _tableCell(subject.grade, align: pw.TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Container(
      color: PdfColors.grey300,
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _tableCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: pw.Text(
        text,
        textAlign: align,
        style: const pw.TextStyle(fontSize: 10.5),
      ),
    );
  }

  static pw.Widget _buildResultBanner(ResultSummaryModel summary) {
    final color = summary.isPass ? PdfColors.green100 : PdfColors.red100;

    final textColor = summary.isPass ? PdfColors.green900 : PdfColors.red900;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      decoration: pw.BoxDecoration(
        color: color,
        border: pw.Border.all(width: 1),
      ),
      child: pw.Center(
        child: pw.Text(
          summary.isPass ? 'RESULT : PASS' : 'RESULT : FAIL',
          style: pw.TextStyle(
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  static pw.Widget _buildSummary(ResultSummaryModel summary) {
    pw.Widget item(String title, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 75,
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
            ),
          ],
        ),
      );
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: .8)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "RESULT SUMMARY",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
          ),

          pw.SizedBox(height: 10),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  children: [
                    item("Subjects", summary.totalSubjects.toString()),
                    item("Average", summary.averageMarks.toStringAsFixed(2)),
                  ],
                ),
              ),

              pw.SizedBox(width: 25),

              pw.Expanded(
                child: pw.Column(
                  children: [
                    item("Total Marks", summary.totalMarks.toString()),
                    item("Grade", summary.grade),
                    item("GPA", summary.gpa.toStringAsFixed(2)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSignature(SchoolSettingsModel? settings) {
    return pw.Column(
      children: [
        pw.Divider(),

        pw.SizedBox(height: 12),

        pw.Text(
          "Authorized Signatories",
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),

        pw.SizedBox(height: 30),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // Class Teacher
            pw.Column(
              children: [
                pw.Container(
                  width: 150,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(top: pw.BorderSide(width: .8)),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "Class Teacher",
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),

            // Principal
            pw.Column(
              children: [
                pw.Container(
                  width: 150,
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(top: pw.BorderSide(width: .8)),
                  ),
                ),

                pw.SizedBox(height: 5),

                if (settings != null && settings.principalName.isNotEmpty)
                  pw.Text(
                    settings.principalName,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                if (settings != null &&
                    settings.principalDesignation.isNotEmpty)
                  pw.Text(
                    settings.principalDesignation,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    final now = DateTime.now();

    final date =
        "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";

    return pw.Column(
      children: [
        pw.Divider(),

        pw.SizedBox(height: 5),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Generated on : $date",
              style: const pw.TextStyle(fontSize: 9),
            ),

            pw.Text(
              "Student Result App",
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
