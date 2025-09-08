import 'package:smart_faker/smart_faker.dart';
import 'package:intl/intl.dart';

void main() {
  final faker = SmartFaker(seed: 12345);

  print('🏥 Healthcare Data Generation Examples');
  print('=' * 60);

  // Patient Information
  print('\n👤 Patient Information:');
  print('Patient ID: ${faker.healthcare.patientId()}');
  print('MRN: ${faker.healthcare.medicalRecordNumber()}');
  print('Blood Type: ${faker.healthcare.bloodType()}');
  print('Insurance: ${faker.healthcare.insuranceProvider()}');
  print('Policy #: ${faker.healthcare.insurancePolicyNumber()}');

  // Medical Staff
  print('\n👨‍⚕️ Medical Staff:');
  print('Doctor: ${faker.healthcare.doctorName()}');
  print('Specialty: ${faker.healthcare.specialty()}');
  print('Hospital: ${faker.healthcare.hospitalName()}');

  // Vital Signs
  print('\n📊 Vital Signs:');
  print('Blood Pressure: ${faker.healthcare.bloodPressure()}');
  print('Heart Rate: ${faker.healthcare.heartRate()} bpm');
  print('Temperature: ${faker.healthcare.temperature()}');
  print('BMI: ${faker.healthcare.bmi().toStringAsFixed(1)}');

  // Medical Conditions & Treatments
  print('\n💊 Medical Information:');
  print('Diagnosis: ${faker.healthcare.diagnosis()}');
  print('Medication: ${faker.healthcare.medication()}');
  print('Dosage: ${faker.healthcare.dosage()}');
  print('Test: ${faker.healthcare.medicalTest()}');

  // Allergies
  print('\n⚠️ Allergies:');
  for (int i = 0; i < 3; i++) {
    print('  - ${faker.healthcare.allergy()}');
  }

  // Vaccinations
  print('\n💉 Vaccination History:');
  for (int i = 0; i < 3; i++) {
    print('  - ${faker.healthcare.vaccination()}');
  }

  // Appointments
  print('\n📅 Next Appointment:');
  final appointment = faker.healthcare.appointmentTime();
  print('Date: ${DateFormat('MMM dd, yyyy HH:mm').format(appointment)}');
  print('Status: ${faker.healthcare.appointmentStatus()}');

  // Complete Medical Record
  print('\n📋 Complete Medical Record:');
  print('-' * 40);
  final record = faker.healthcare.medicalRecord();
  print('Patient ID: ${record['patientId']}');
  print('MRN: ${record['mrn']}');
  print('Blood Type: ${record['bloodType']}');

  final allergies = record['allergies'] as List;
  if (allergies.isNotEmpty) {
    print('Allergies: ${allergies.join(', ')}');
  } else {
    print('Allergies: None');
  }

  print('\nCurrent Medications:');
  final meds = record['currentMedications'] as List;
  for (final med in meds) {
    print('  - ${med['name']}: ${med['dosage']}');
  }

  print('\nDiagnoses:');
  final diagnoses = record['diagnoses'] as List;
  for (final diagnosis in diagnoses) {
    print('  - $diagnosis');
  }

  print('\nVital Signs:');
  final vitals = record['vitalSigns'] as Map;
  print('  Blood Pressure: ${vitals['bloodPressure']}');
  print('  Heart Rate: ${vitals['heartRate']} bpm');
  print('  Temperature: ${vitals['temperature']}');
  print('  BMI: ${vitals['bmi']}');

  print('\nInsurance:');
  final insurance = record['insurance'] as Map;
  print('  Provider: ${insurance['provider']}');
  print('  Policy #: ${insurance['policyNumber']}');

  print('\nPrimary Doctor: ${record['primaryDoctor']}');
  final lastVisit = DateTime.parse(record['lastVisit'] as String);
  print('Last Visit: ${DateFormat('MMM dd, yyyy').format(lastVisit)}');

  // Localization Examples
  print('\n🌏 Localization Examples:');
  print('-' * 40);

  // Chinese (Traditional)
  final fakerZh = SmartFaker(locale: 'zh_TW', seed: 12345);
  print('\n繁體中文:');
  print('醫生: ${fakerZh.healthcare.doctorName()}');
  print('專科: ${fakerZh.healthcare.specialty()}');
  print('醫院: ${fakerZh.healthcare.hospitalName()}');
  print('診斷: ${fakerZh.healthcare.diagnosis()}');
  print('藥物: ${fakerZh.healthcare.medication()}');

  // Japanese
  final fakerJa = SmartFaker(locale: 'ja_JP', seed: 12345);
  print('\n日本語:');
  print('医師: ${fakerJa.healthcare.doctorName()}');
  print('専門: ${fakerJa.healthcare.specialty()}');
  print('病院: ${fakerJa.healthcare.hospitalName()}');
  print('診断: ${fakerJa.healthcare.diagnosis()}');
  print('薬: ${fakerJa.healthcare.medication()}');

  print('\n✨ Healthcare module examples completed!');
}
