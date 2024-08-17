create database clinic;
use clinic;

-- Patients Table
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    PhoneNumber VARCHAR(15),
    Address VARCHAR(255)
);

-- Insert values in the Patients Table


INSERT INTO Patients VALUES(1, 'Shivraj', 'Dhumal', '2002-06-15', 'M', '7559372305', 'Karad');
INSERT INTO Patients VALUES(2, 'Shravani', 'Khandagale', '2003-03-22', 'F', '9105555678', 'Satara');
INSERT INTO Patients VALUES(3, 'Siddharth', 'Jagdale', '2000-04-21', 'M', '9845558765','Shivajinagar Pune' );
INSERT INTO Patients VALUES(4, 'Vaishnavi', 'Vanve', '1982-07-30', 'F', '77675554321', 'Sangli');
INSERT INTO Patients VALUES(5, 'Rajvardhan', 'Raut', '2003-09-12', 'M', '8455556789', 'Kolhapur');
INSERT INTO Patients VALUES(6, 'Tejaswini', 'Patil', '2000-01-05', 'F', '7235553456', 'Aalandi Pune');
INSERT INTO Patients VALUES(7, 'Karan', 'Khandagale', '1988-12-25', 'M', '9315552345', 'Kondhawa Pune');
INSERT INTO Patients VALUES(8, 'Gaurav', 'Patil', '1972-10-23', 'M', '9865556543', 'Banglore');
INSERT INTO Patients VALUES(9, 'Siddhi', 'Shinde', '1989-08-19', 'F', '8805553210', 'Wakad Pune');
INSERT INTO Patients VALUES(10, 'Samruddhi', 'Patil', '2001-08-19', 'F', '9805553210', 'Karad');

select * from Patients;

-- Doctors Table

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15),
    HireDate DATE NOT NULL
);

-- Insert values in the Doctors Table


INSERT INTO Doctors VALUES(101, 'Eshaa', 'Niakm', 'Cardiology', '7345551111', '2015-03-15');
INSERT INTO Doctors VALUES(102,'Divya', 'Sathe', 'Orthopedics', '555-2222', '2017-06-20');
INSERT INTO Doctors VALUES(103,'Sarthak', 'Patil', 'Neurology', '9745553333', '2018-09-01');
INSERT INTO Doctors VALUES(104,'Manasi', 'Bugde', 'Pediatrics', '9865554444', '2016-12-12');
INSERT INTO Doctors VALUES(105,'Omprasad', 'Ugale', 'Dermatology', '9786451290', '2019-02-14');
INSERT INTO Doctors VALUES(106,'Prashant','Patil', 'Internal Medicine', '9235556666', '2020-08-23');
INSERT INTO Doctors VALUES(107,'Sophia', 'Mujawar', 'General Surgery', '8675557777', '2014-11-30');
INSERT INTO Doctors VALUES(108,'Pravin', 'Mane', 'Ophthalmology', '5558888', '2015-07-04');
INSERT INTO Doctors VALUES(109,'Avantika', 'Madane', 'Psychiatry', '8765559999', '2016-01-22');
INSERT INTO Doctors VALUES(110,'Vinayak', 'Shejale', 'Oncology', '9875550000', '2018-10-09');
select * from Doctors;


-- Appointment Table

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert values in the Appointment Table

INSERT INTO Appointments VALUES(501, 1, 106, '2024-08-10 09:00:00', 'Routine Checkup' );
INSERT INTO Appointments VALUES(502, 2, 102, '2024-08-11 10:00:00', 'Orthopedic Consultation');
INSERT INTO Appointments VALUES(503, 3, 103, '2024-08-12 11:00:00', 'Neurological Evaluation');
INSERT INTO Appointments VALUES(504, 4, 104, '2024-08-13 14:00:00', 'Pediatric Review');
INSERT INTO Appointments VALUES(505, 5, 105, '2024-08-14 15:00:00', 'Skin Issue');
INSERT INTO Appointments VALUES(506, 6, 106, '2024-08-15 09:30:00', 'Internal Medicine Follow-up');
INSERT INTO Appointments VALUES(507, 7, 107, '2024-08-16 10:30:00', 'Surgical Consultation');
INSERT INTO Appointments VALUES(508, 8, 108, '2024-08-17 11:30:00', 'Eye Examination');
INSERT INTO Appointments VALUES(509, 9, 109, '2024-08-18 13:00:00', 'Mental Health Evaluation');
INSERT INTO Appointments VALUES(510, 10, 110, '2024-08-19 14:30:00', 'Cancer Screening');

select * from  Appointments;

-- CREATE VIEWS 

-- 1. SIMPLE VIEW 

-- Create a simple view to display Doctors and their Specialization.
CREATE VIEW DoctorSpecialization AS
SELECT CONCAT(D.FirstName, " " ,D.LastName) AS Doctor_name, D.specialization from Doctors D;

select * from  DoctorSpecialization;

-- 2. COMPLEX VIEWS 

-- Create a view to get Patient Appointment Information.

CREATE VIEW PatientAppointmentsDetails AS
SELECT p.PatientID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, a.AppointmentID, a.AppointmentDate, d.FirstName AS Doctor_FirstName, d.LastName AS Doctor_LastName
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID;

select * from PatientAppointmentsDetails;

-- STORED PROCEDURES

-- 1. Stored Procedure to Get Patient's name and  Contact number for any emergency.

delimiter //
CREATE PROCEDURE GetPatientInformation(
    IN pPatientID INT,
    OUT pFirstName VARCHAR(50),
    OUT pGender CHAR(1),
    OUT pPhoneNumber VARCHAR(15)
)
BEGIN
    SELECT FirstName, Gender, PhoneNumber
    INTO pFirstName, pGender, pPhoneNumber
    FROM Patients
    WHERE PatientID = pPatientID;
END //

call GetPatientInformation(1,@FirstName,@Gender,@PhoneNumber);
select @FirstName,@Gender,@PhoneNumber;

-- 2. Stored Procedure to update Doctor's Specialization


-- Set delimiter to handle the procedure definition
DELIMITER //

-- Create the stored procedure
CREATE PROCEDURE UpdateDoctorSpecialization(
    IN pDoctorID INT,
    INOUT pNewSpecialization VARCHAR(100),
    OUT pOldSpecialization VARCHAR(100)
)
BEGIN
    -- Retrieve the old specialization
    SELECT Specialization INTO pOldSpecialization
    FROM Doctors
    WHERE DoctorID = pDoctorID;

    -- Update the doctor's specialization
    UPDATE Doctors
    SET Specialization = pNewSpecialization
    WHERE DoctorID = pDoctorID;
END //

-- Reset delimiter to default
DELIMITER ;

-- Declare variables for the procedure call
SET @newSpec = 'Cardiology';
SET @oldSpec = '';

-- Call the stored procedure
CALL UpdateDoctorSpecialization(105, @newSpec, @oldSpec);

-- Retrieve the output
SELECT @newSpec AS UpdatedSpecialization, @oldSpec AS PreviousSpecialization;



-- FUNCTIONS

-- 1. Stored Function To get Age of the Patient.

delimiter //
CREATE FUNCTION GetPatientAge(pPatientID INT)
RETURNS INT
deterministic
BEGIN
    DECLARE vAge INT;
    SELECT TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) INTO vAge
    FROM Patients
    WHERE PatientID = pPatientID;
    RETURN vAge;
END //

select GetPatientAge(1) as Age;
select GetPatientAge(3) as Age;
select GetPatientAge(10) as Age;


-- 2 .Stored Function to Count Appointments For Doctors.

DELIMITER //

CREATE FUNCTION CountAppointmentsForDoctor(pDoctorID INT)
RETURNS INT
deterministic
BEGIN
    DECLARE vCount INT;
    SELECT COUNT(*) INTO vCount
    FROM Appointments
    WHERE DoctorID = pDoctorID;
    RETURN vCount;
END //


SELECT CountAppointmentsForDoctor(106) AS Appointment_Count;
SELECT CountAppointmentsForDoctor(110) AS Appointment_Count;


-- TRIGGER 

-- 1. Trigger to maintain the appointment cannot be scheduled in the past.

DELIMITER //

 CREATE TRIGGER BeforeInsertAppointment
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.AppointmentDate < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot schedule an appointment in the past';
    END IF;
END //

-- Assuming DoctorID and PatientID values exist in the database
INSERT INTO Appointments (DoctorID, PatientID, AppointmentDate)
VALUES (101, 111, '2024-05-08 10:00:00');



