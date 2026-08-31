

/*
===========================================================
 Create the Database
===========================================================
*/

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO


/*
===========================================================
 Create the Users Table
===========================================================
*/

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    Phone NVARCHAR(30) NULL,
    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Users_CreatedAt
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_Users
        PRIMARY KEY (UserID),

    CONSTRAINT UQ_Users_Email
        UNIQUE (Email),

    CONSTRAINT CK_Users_Role
        CHECK (Role IN (N'Organiser', N'Participant'))
);
GO


/*
===========================================================
 Create the Events Table
===========================================================
*/

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) NOT NULL,
    EventName NVARCHAR(150) NOT NULL,
    EventType NVARCHAR(30) NOT NULL,
    Description NVARCHAR(1000) NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    OrganiserID INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Events_CreatedAt
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_Events
        PRIMARY KEY (EventID),

    CONSTRAINT FK_Events_Organiser
        FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID),

    CONSTRAINT CK_Events_Type
        CHECK (EventType IN (N'Running', N'Walking', N'Cycling'))
);
GO


/*
===========================================================
: Create the Routes Table
===========================================================
*/

CREATE TABLE Routes
(
    RouteID INT IDENTITY(1,1) NOT NULL,
    EventID INT NOT NULL,
    RouteName NVARCHAR(150) NOT NULL,
    DistanceKm DECIMAL(6,2) NOT NULL,
    StartPoint NVARCHAR(200) NOT NULL,
    FinishPoint NVARCHAR(200) NOT NULL,
    RouteInformation NVARCHAR(1000) NULL,

    CONSTRAINT PK_Routes
        PRIMARY KEY (RouteID),

    CONSTRAINT UQ_Routes_Event
        UNIQUE (EventID),

    CONSTRAINT FK_Routes_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT CK_Routes_Distance
        CHECK (DistanceKm > 0)
);
GO


/*
===========================================================
 Create the Categories Table
===========================================================
*/

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) NOT NULL,
    EventID INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(6,2) NULL,
    MaximumParticipants INT NULL,
    EntryFee DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Categories
        PRIMARY KEY (CategoryID),

    CONSTRAINT FK_Categories_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT UQ_Categories_Event_Name
        UNIQUE (EventID, CategoryName),

    CONSTRAINT CK_Categories_Distance
        CHECK (DistanceKm IS NULL OR DistanceKm > 0),

    CONSTRAINT CK_Categories_MaxParticipants
        CHECK (MaximumParticipants IS NULL OR MaximumParticipants > 0),

    CONSTRAINT CK_Categories_EntryFee
        CHECK (EntryFee >= 0)
);
GO


/*
===========================================================
 Create the Enrolments Table
===========================================================
*/

CREATE TABLE Enrolments
(
    EnrolmentID INT IDENTITY(1,1) NOT NULL,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL
        CONSTRAINT DF_Enrolments_EnrolmentDate
        DEFAULT SYSUTCDATETIME(),

    Status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Enrolments_Status
        DEFAULT N'Confirmed',

    CONSTRAINT PK_Enrolments
        PRIMARY KEY (EnrolmentID),

    CONSTRAINT FK_Enrolments_Participant
        FOREIGN KEY (ParticipantID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Enrolments_Event
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT FK_Enrolments_Category
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT UQ_Enrolments_Participant_Event
        UNIQUE (ParticipantID, EventID),

    CONSTRAINT CK_Enrolments_Status
        CHECK (Status IN (N'Pending', N'Confirmed', N'Cancelled'))
);
GO


/*
===========================================================
 Create the Results Table
===========================================================
*/

CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) NOT NULL,
    EnrolmentID INT NOT NULL,
    FinishPosition INT NULL,
    FinishTime TIME(0) NULL,
    ResultStatus NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Results_Status
        DEFAULT N'Finished',

    CONSTRAINT PK_Results
        PRIMARY KEY (ResultID),

    CONSTRAINT UQ_Results_Enrolment
        UNIQUE (EnrolmentID),

    CONSTRAINT FK_Results_Enrolment
        FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolments(EnrolmentID),

    CONSTRAINT CK_Results_Position
        CHECK (FinishPosition IS NULL OR FinishPosition > 0),

    CONSTRAINT CK_Results_Status
        CHECK (ResultStatus IN (N'Finished', N'DNF', N'DNS', N'Disqualified'))
);
GO


/*
===========================================================
 Insert the Required Users
===========================================================
*/

INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role, Phone)
VALUES
    (N'Lerato', N'Mokoena', N'lerato.mokoena@raceday.co.za', N'$2a$12$e8Y9k4B9g2Lq4.Z8k1G0u.eK7m6F2d4J9h8G3s2W1x0Y9z8A7B6C', N'Organiser', N'+27821234567'),
    (N'Daniel', N'Naidoo', N'daniel.naidoo@raceday.co.za', N'$2a$12$f9Z0l5C0h3Mr5.A9l2H1v.fL8n7G3e5K0i9H4t3X2y1Z0a9B8C7D', N'Organiser', N'+27839876543'),
    (N'Ayanda', N'Ndlovu', N'ayanda.ndlovu@raceday.co.za', N'$2a$12$g0A1m6D1i4Ns6.B0m3I2w.gM9o8H4f6L1j0I5u4Y3z2A1b0C9D8E', N'Participant', N'+27711122334'),
    (N'Jason', N'Williams', N'jason.williams@raceday.co.za', N'$2a$12$h1B2n7E2j5Ot7.C1n4J3x.hN0p9I5g7M2k1J6v5Z4a3B2c1D0E9F', N'Participant', N'+27725556677');
GO


/*
===========================================================
 Insert 3 Events
===========================================================
*/

INSERT INTO Events (EventName, EventType, Description, EventDate, StartTime, Location, OrganiserID)
VALUES
    (N'Cape Peninsula Road Run', N'Running', N'A scenic road running event along selected Cape Peninsula roads.', '2026-10-18', '06:30:00', N'Cape Town, Western Cape', 1),
    (N'Johannesburg Community Walk', N'Walking', N'A community walking event suitable for recreational participants.', '2026-11-07', '07:00:00', N'Johannesburg, Gauteng', 2),
    (N'Durban Coastal Cycle Challenge', N'Cycling', N'A coastal cycling event for recreational and experienced riders.', '2026-11-22', '06:00:00', N'Durban, KwaZulu-Natal', 1);
GO


/*
===========================================================
: Insert Routes
===========================================================
*/

INSERT INTO Routes (EventID, RouteName, DistanceKm, StartPoint, FinishPoint, RouteInformation)
VALUES
    (1, N'Peninsula 21K Route', 21.10, N'Green Point Stadium', N'Camps Bay Promenade', N'Scenic road route through Cape Peninsula coastal areas.'),
    (2, N'Community 8K Walk Route', 8.00, N'Emmarentia Dam Gate 1', N'Emmarentia Main Park', N'Accessible community walking route through botanical parklands.'),
    (3, N'Coastal 60K Cycle Route', 60.00, N'Moses Mabhida Stadium', N'Ballito Promenade', N'Rolling coastal highway route with controlled traffic sections.');
GO


/*
===========================================================
 Insert Categories
===========================================================
*/

INSERT INTO Categories (EventID, CategoryName, DistanceKm, MaximumParticipants, EntryFee)
VALUES
    (1, N'21.1 km Open', 21.10, 1000, 250.00),
    (1, N'10 km Fun Run', 10.00, 800, 150.00),
    (2, N'8 km Community Walk', 8.00, 600, 80.00),
    (2, N'4 km Family Walk', 4.00, 400, 50.00),
    (3, N'60 km Open Cycle', 60.00, 700, 300.00),
    (3, N'30 km Social Ride', 30.00, 500, 180.00);
GO


/*
===========================================================
STEP 41: Insert Enrolments
===========================================================
*/

INSERT INTO Enrolments (ParticipantID, EventID, CategoryID, Status)
VALUES
    (3, 1, 1, N'Confirmed'),
    (4, 1, 2, N'Confirmed'),
    (3, 2, 3, N'Confirmed'),
    (4, 2, 4, N'Confirmed'),
    (3, 3, 5, N'Confirmed'),
    (4, 3, 6, N'Confirmed');
GO


/*
===========================================================
 Insert Sample Results
===========================================================
*/

INSERT INTO Results (EnrolmentID, FinishPosition, FinishTime, ResultStatus)
VALUES
    (1, 12, '01:48:32', N'Finished'),
    (2, 31, '00:58:44', N'Finished'),
    (3, NULL, NULL, N'DNS'),
    (4, 44, '01:12:10', N'Finished');
GO


/*
===========================================================
Displaying tables
===========================================================

*/

-- 1. Display Users
SELECT * FROM Users;
GO

-- 2. Display Events
SELECT * FROM Events;
GO

-- 3. Display Routes
SELECT * FROM Routes;
GO

-- 4. Display Categories
SELECT * FROM Categories;
GO

-- 5. Display Enrolments
SELECT * FROM Enrolments;
GO

-- 6. Display Results
SELECT * FROM Results;
GO
