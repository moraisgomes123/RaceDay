# RaceDay

# RaceDay Event Management System

## 1. Project Overview

RaceDay is an event management system designed to support road running, walking and cycling events in South Africa.

The system is designed around two main user roles: Organisers and Participants.

Organisers are responsible for creating and managing events, routes, categories, participant enrolments and event results.

Participants can create an account, browse available events, enrol in events, select categories and view their results.

This repository contains the Part 1 planning and database deliverables for the RaceDay project.

---

## 2. User Roles

### Organiser

An Organiser is responsible for managing events and event information.

The Organiser can:

* Create events
* Update events
* Delete events
* Manage event categories
* Manage routes
* View participant enrolments
* Capture and manage participant results

### Participant

A Participant uses the system to take part in events.

The Participant can:

* Register an account
* Log in
* View available events
* View event categories
* Enrol in an event
* View their enrolments
* View their personal results

---

## 3. Project Structure

The project follows the required folder structure:

```text
RaceDay/
│
├── .github/
│   └── workflows/
│       └── part1.yml
│
├── docs/
│   ├── RaceDay_ERD.png
│   ├── API_Endpoint_Plan.md
│   └── RaceDay_Database.sql
│
└── README.md
```

### `.github/workflows`

Contains the GitHub Actions workflow used to validate the required Part 1 files.

### `docs`

Contains the main Part 1 documentation and database deliverables.

### `README.md`

Contains information about the project, setup instructions, roles, database, API planning and CI/CD validation.

---

# 4. Part 1 Deliverables

Part 1 consists of three main deliverables:

1. Entity Relationship Diagram (ERD)
2. API Endpoint Plan
3. SQL Server Database Script

These deliverables form the design foundation for the RaceDay system.

---

# 5. Entity Relationship Diagram

The RaceDay database contains six main entities:

1. Users
2. Events
3. Routes
4. Categories
5. Enrolments
6. Results

The ERD contains the attributes, primary keys, foreign keys and relationships between these entities.

## Main Relationships

### Users and Events

One Organiser can manage many Events.

```text
Users 1 ──────── 1..* Events
```

The `OrganiserID` foreign key in the Events table identifies the Organiser responsible for the event.

### Events and Routes

Each Event has one Route.

```text
Events 1 ──────── 1 Routes
```

The `EventID` in the Routes table identifies the event to which the route belongs.

### Events and Categories

One Event can contain many Categories.

```text
Events 1 ──────── 1..* Categories
```

### Users and Enrolments

One Participant can have many Enrolments.

```text
Users 1 ──────── 1..* Enrolments
```

The `ParticipantID` foreign key identifies the participant.

### Events and Enrolments

One Event can have many Enrolments.

```text
Events 1 ──────── 1..* Enrolments
```

### Categories and Enrolments

One Category can have many Enrolments.

```text
Categories 1 ──────── 1..* Enrolments
```

### Enrolments and Results

An Enrolment can have zero or one Result.

```text
Enrolments 1 ──────── 0..1 Results
```

This allows an enrolment to exist before the participant completes the event.

The complete ERD is available here:

`docs/RaceDay_ERD.png`

---

# 6. API Endpoint Plan

The API Endpoint Plan defines the REST API that will be implemented in the later stages of the project.

The endpoint plan includes:

* HTTP method
* Route
* Description
* Role required
* Request body
* Expected response

The plan also identifies successful and failure response codes.

The complete API Endpoint Plan is available here:

`docs/API_Endpoint_Plan.md`

## Main API Areas

### Authentication

```text
POST /api/auth/register
POST /api/auth/login
```

### User Profile

```text
GET /api/users/me
PUT /api/users/me
```

### Events

```text
GET /api/events
GET /api/events/{eventId}
POST /api/events
PUT /api/events/{eventId}
DELETE /api/events/{eventId}
```

### Categories

```text
GET /api/categories
GET /api/events/{eventId}/categories
POST /api/events/{eventId}/categories
PUT /api/categories/{categoryId}
DELETE /api/categories/{categoryId}
```

### Enrolments

```text
POST /api/events/{eventId}/enrolments
GET /api/enrolments/me
GET /api/events/{eventId}/enrolments
DELETE /api/enrolments/{enrolmentId}
```

### Results

```text
POST /api/events/{eventId}/results
GET /api/results/me
GET /api/events/{eventId}/results
PUT /api/results/{resultId}
DELETE /api/results/{resultId}
```

---

# 7. SQL Server Database

The RaceDay database is implemented using Microsoft SQL Server.

The database contains the following tables:

```text
Users
Events
Routes
Categories
Enrolments
Results
```

The SQL script defines:

* Primary keys
* Foreign keys
* NOT NULL constraints
* UNIQUE constraints
* DEFAULT constraints
* CHECK constraints
* Seed data
* Relationships between tables

The complete SQL script is available at:

`docs/RaceDay_Database.sql`

---

# 8. Database Setup

## Requirements

Before running the database script, install:

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)

## Steps

1. Open SQL Server Management Studio.
2. Connect to your SQL Server instance.
3. Open `docs/RaceDay_Database.sql`.
4. Execute the complete script.
5. Confirm that the `RaceDay` database has been created.
6. Expand the database and open the Tables section.

The following tables should be visible:

```text
dbo.Users
dbo.Events
dbo.Routes
dbo.Categories
dbo.Enrolments
dbo.Results
```

## Verify the Database

Run:

```sql
USE RaceDay;

SELECT * FROM Users;
SELECT * FROM Events;
SELECT * FROM Routes;
SELECT * FROM Categories;
SELECT * FROM Enrolments;
SELECT * FROM Results;
```

The script contains sample data for Organisers, Participants, Events, Routes, Categories, Enrolments and Results.


## screen shots of queries

-- 1. Display Users
SELECT * FROM Users;

<img width="788" height="109" alt="image" src="https://github.com/user-attachments/assets/9a593660-a19a-4814-bf25-7eaf9024d13e" />

-- 2. Display Events
SELECT * FROM Events;

<img width="790" height="104" alt="image" src="https://github.com/user-attachments/assets/f9600990-fb26-444a-b0bc-71c148db7a73" />


-- 3. Display Routes
SELECT * FROM Routes;

<img width="650" height="112" alt="image" src="https://github.com/user-attachments/assets/883c2edb-5ffa-44ae-b78c-b1805474b5dd" />

-- 4. Display Categories
SELECT * FROM Categories;

<img width="414" height="134" alt="image" src="https://github.com/user-attachments/assets/29ad6562-a16e-40fc-a341-7cf4b98046c8" />

-- 5. Display Enrolments
SELECT * FROM Enrolments;

<img width="400" height="134" alt="image" src="https://github.com/user-attachments/assets/9a4ab675-9087-422f-ba95-986fae76351c" />

-- 6. Display Results
SELECT * FROM Results;

<img width="296" height="86" alt="image" src="https://github.com/user-attachments/assets/4b1e84ed-cf9d-4fd8-a1da-927db79029c9" />

---

# 9. Seed Data

The database contains realistic sample data covering all entities.

The Users table contains:

* 2 Organisers
* 2 Participants

The Events table contains:

* Running event
* Walking event
* Cycling event

Each event has associated route and category information.

The Enrolments table contains sample participant registrations.

The Results table contains sample event results.

---

# 10. API Response Codes

The API plan considers both successful and unsuccessful requests.

Common response codes include:

| Status Code | Meaning                                  |
| ----------- | ---------------------------------------- |
| 200         | Request completed successfully           |
| 201         | Resource created successfully            |
| 204         | Request completed with no response body  |
| 400         | Invalid request                          |
| 401         | Authentication required or invalid       |
| 403         | User does not have permission            |
| 404         | Requested resource was not found         |
| 409         | Conflict, such as duplicate registration |
| 500         | Internal server error                    |

---

# 11. GitHub Actions / CI

GitHub Actions is used to validate the required Part 1 project files.

The workflow checks that:

* `README.md` exists
* `docs` exists
* The ERD exists
* The API Endpoint Plan exists
* The SQL script exists
* The SQL script is not empty
* The API Endpoint Plan is not empty

The workflow is located at:

```text
.github/workflows/part1.yml
```

## CI Build Status

After pushing the project to GitHub, open the **Actions** tab and confirm that the workflow completes successfully.

Add the screenshot of the successful green build below.

### Successful CI Build

<img width="551" height="259" alt="Screenshot 2026-08-30 154634" src="https://github.com/user-attachments/assets/f930beb6-2c2e-486f-af1f-f328a1980ff1" />


<img width="930" height="490" alt="Screenshot 2026-08-30 154652" src="https://github.com/user-attachments/assets/1bd91b93-90b7-4914-a541-7c1fc04505c0" />

<img width="681" height="242" alt="Screenshot 2026-08-30 154612" src="https://github.com/user-attachments/assets/fa15a9a9-55ad-47fd-87f7-10b7c339f03b" />




---

# 12. GitHub Repository

The complete RaceDay Part 1 project is maintained in GitHub.

Repository:

`ADD YOUR GITHUB REPOSITORY LINK HERE`

The repository contains the complete Part 1 documentation, SQL script, ERD and CI workflow.

---

# 13. Commit History

The project uses meaningful Git commits to document the development process.

Examples of meaningful commits include:

```text
Create RaceDay Part 1 project structure
Add initial README
Add Users entity to ERD
Add Events entity to ERD
Add Routes entity to ERD
Add Categories entity to ERD
Add Enrolments entity to ERD
Add Results entity to ERD
Add ERD relationships
Correct ERD cardinalities
Add authentication API endpoints
Add user profile endpoints
Add event API endpoints
Add category API endpoints
Add enrolment API endpoints
Add result API endpoints
Create Users SQL table
Create Events and Routes SQL tables
Create Categories and Enrolments SQL tables
Create Results SQL table
Add database seed data
Add SQL verification queries
Add GitHub Actions workflow
Complete project README
```

The GitHub repository should contain at least 20 meaningful commits for Part 1.

---

# 14. Video Presentation

The Part 1 presentation demonstrates the design and implementation decisions made for the RaceDay project.

The presentation covers:

* Project overview
* Organiser and Participant roles
* ERD design
* Entities and attributes
* Primary and foreign keys
* Cardinality and relationships
* API Endpoint Plan
* Request and response design
* Failure response codes
* SQL database structure
* SQL script execution in SSMS
* Seed data
* GitHub repository
* GitHub Actions CI workflow

### YouTube Video

https://www.youtube.com/watch?v=8F7hJiJ_rQk

---

# 15. Final Submission Checklist

Before submitting Part 1, confirm that:

* [ ] GitHub repository is accessible
* [ ] `README.md` is complete
* [ ] `/docs` folder exists
* [ ] ERD is inside `/docs`
* [ ] API Endpoint Plan is inside `/docs`
* [ ] SQL script is inside `/docs`
* [ ] ERD matches the SQL database
* [ ] All six entities are included
* [ ] PKs and FKs are correctly defined
* [ ] Cardinalities are correct
* [ ] SQL script runs successfully in SSMS
* [ ] Seed data covers all entities
* [ ] At least 2 Organisers exist
* [ ] At least 2 Participants exist
* [ ] At least 3 Events exist
* [ ] Each Event has Categories
* [ ] GitHub Actions workflow passes
* [ ] Green CI screenshot is included
* [ ] At least 20 meaningful commits are present
* [ ] YouTube presentation is uploaded as Unlisted
* [ ] YouTube link is added to README
