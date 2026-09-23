UPDATE `users` SET `licenseClass` = 'HANG_CE' WHERE `licenseClass` = 'HANG_FC';
UPDATE `users` SET `licenseClass` = 'HANG_D1' WHERE `licenseClass` = 'HANG_D';
UPDATE `vehicle_types` SET `requiredLicenseClass` = 'HANG_CE' WHERE `requiredLicenseClass` = 'HANG_FC';
UPDATE `vehicle_types` SET `requiredLicenseClass` = 'HANG_D1' WHERE `requiredLicenseClass` = 'HANG_D';
