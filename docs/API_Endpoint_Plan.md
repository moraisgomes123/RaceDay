# RaceDay API Endpoint Plan

## 1. Overview

The RaceDay API will provide the backend services for the RaceDay Event Management System.

The system supports two main roles:

* **Organiser**
* **Participant**

The API will support authentication, user profile management, event management, route and category management, participant enrolments and event results.

The API is planned as a RESTful API and will use JSON for request and response bodies.

---

# 2. User Roles

## Organiser

An Organiser can:

* Create events
* View events
* Update events
* Delete events
* Manage event categories
* Manage routes
* View participant enrolments
* Capture event results
* Update results
* Delete results

## Participant

A Participant can:

* Register an account
* Log in
* View events
* View event categories
* Enrol in an event
* View their own enrolments
* Cancel their enrolment
* View their own results
* Update their own profile

---

# 3. Standard HTTP Response Codes

The API will use the following HTTP response codes:

| Status Code               | Meaning                                                         |
| ------------------------- | --------------------------------------------------------------- |
| 200 OK                    | Request completed successfully                                  |
| 201 Created               | A new resource was successfully created                         |
| 204 No Content            | Request completed successfully with no response body            |
| 400 Bad Request           | Request contains invalid or missing information                 |
| 401 Unauthorized          | User is not authenticated or authentication details are invalid |
| 403 Forbidden             | Authenticated user does not have permission                     |
| 404 Not Found             | Requested resource does not exist                               |
| 409 Conflict              | Request conflicts with existing data                            |
| 500 Internal Server Error | Unexpected server-side error                                    |

---

# 4. Authentication Endpoints

## 4.1 Register User

| HTTP Method | Route                | Description                                     | Role Required | Request Body                                                                                                                                                 | Expected Response                                                                                                                                                                   |
| ----------- | -------------------- | ----------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/auth/register` | Creates a new Organiser or Participant account. | Public        | `{ "firstName": "Ayanda", "lastName": "Ndlovu", "email": "ayanda@example.com", "password": "Password123!", "role": "Participant", "phone": "+27733003003" }` | **201 Created** with created user information. **400 Bad Request** for invalid data. **409 Conflict** if email already exists. **500 Internal Server Error** for unexpected errors. |

### Example successful response

```json
{
  "userId": 3,
  "firstName": "Ayanda",
  "lastName": "Ndlovu",
  "email": "ayanda@example.com",
  "role": "Participant"
}
```

---

## 4.2 Login

| HTTP Method | Route             | Description                                                              | Role Required | Request Body                                                    | Expected Response                                                                                                                                                                      |
| ----------- | ----------------- | ------------------------------------------------------------------------ | ------------- | --------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/auth/login` | Authenticates a registered user and provides authentication information. | Public        | `{ "email": "ayanda@example.com", "password": "Password123!" }` | **200 OK** with authentication information. **400 Bad Request** for missing fields. **401 Unauthorized** for invalid credentials. **500 Internal Server Error** for unexpected errors. |

### Example successful response

```json
{
  "message": "Login successful",
  "userId": 3,
  "role": "Participant"
}
```

---

# 5. User Profile Endpoints

## 5.1 Get Current User Profile

| HTTP Method | Route           | Description                                                          | Role Required            | Request Body | Expected Response                                                                                                                                                           |
| ----------- | --------------- | -------------------------------------------------------------------- | ------------------------ | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/users/me` | Returns the profile information of the currently authenticated user. | Organiser or Participant | None         | **200 OK** with user profile. **401 Unauthorized** if not authenticated. **404 Not Found** if the user does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 5.2 Update Current User Profile

| HTTP Method | Route           | Description                                                          | Role Required            | Request Body                                                               | Expected Response                                                                                                                                                             |
| ----------- | --------------- | -------------------------------------------------------------------- | ------------------------ | -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PUT         | `/api/users/me` | Updates the profile information of the currently authenticated user. | Organiser or Participant | `{ "firstName": "Ayanda", "lastName": "Ndlovu", "phone": "+27733003003" }` | **200 OK** with updated profile. **400 Bad Request** for invalid information. **401 Unauthorized** if not authenticated. **500 Internal Server Error** for unexpected errors. |

---

# 6. Event Endpoints

## 6.1 Get All Events

| HTTP Method | Route         | Description                                 | Role Required | Request Body | Expected Response                                                                    |
| ----------- | ------------- | ------------------------------------------- | ------------- | ------------ | ------------------------------------------------------------------------------------ |
| GET         | `/api/events` | Returns a list of available RaceDay events. | Public        | None         | **200 OK** with list of events. **500 Internal Server Error** for unexpected errors. |

---

## 6.2 Get Event by ID

| HTTP Method | Route                   | Description                                          | Role Required | Request Body | Expected Response                                                                                                              |
| ----------- | ----------------------- | ---------------------------------------------------- | ------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| GET         | `/api/events/{eventId}` | Returns detailed information about a specific event. | Public        | None         | **200 OK** with event details. **404 Not Found** if event does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 6.3 Create Event

| HTTP Method | Route         | Description          | Role Required | Request Body                                                                                                                                                                                         | Expected Response                                                                                                                                                                                                    |
| ----------- | ------------- | -------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/events` | Creates a new event. | Organiser     | `{ "eventName": "Cape Peninsula Road Run", "eventType": "Running", "description": "A road running event.", "eventDate": "2026-10-18", "startTime": "06:30", "location": "Cape Town, Western Cape" }` | **201 Created** with new event. **400 Bad Request** for invalid data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not an Organiser. **500 Internal Server Error** for unexpected errors. |

---

## 6.4 Update Event

| HTTP Method | Route                   | Description                                         | Role Required | Request Body                                                                                                                                                                                              | Expected Response                                                                                                                                                                                                                                                          |
| ----------- | ----------------------- | --------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PUT         | `/api/events/{eventId}` | Updates an existing event managed by the Organiser. | Organiser     | `{ "eventName": "Cape Peninsula Road Run", "eventType": "Running", "description": "Updated event description.", "eventDate": "2026-10-18", "startTime": "06:30", "location": "Cape Town, Western Cape" }` | **200 OK** with updated event. **400 Bad Request** for invalid data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not the authorised Organiser. **404 Not Found** if event does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 6.5 Delete Event

| HTTP Method | Route                   | Description                | Role Required | Request Body | Expected Response                                                                                                                                                                                                                                                                                                                          |
| ----------- | ----------------------- | -------------------------- | ------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| DELETE      | `/api/events/{eventId}` | Deletes an existing event. | Organiser     | None         | **204 No Content** when successfully deleted. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not authorised. **404 Not Found** if event does not exist. **409 Conflict** if the event cannot be deleted because of related enrolments or other dependencies. **500 Internal Server Error** for unexpected errors. |

---

# 7. Route Endpoints

## 7.1 Get Event Route

| HTTP Method | Route                         | Description                                         | Role Required | Request Body | Expected Response                                                                                                                           |
| ----------- | ----------------------------- | --------------------------------------------------- | ------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/events/{eventId}/route` | Returns the route information for a specific event. | Public        | None         | **200 OK** with route information. **404 Not Found** if event or route does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 7.2 Create Event Route

| HTTP Method | Route                         | Description                   | Role Required | Request Body                                                                                                                                                                                        | Expected Response                                                                                                                                                                                                                                                                                            |
| ----------- | ----------------------------- | ----------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| POST        | `/api/events/{eventId}/route` | Creates a route for an event. | Organiser     | `{ "routeName": "Peninsula 21K Route", "distanceKm": 21.1, "startPoint": "Green Point", "finishPoint": "Green Point", "routeInformation": "Road route through selected Cape Peninsula sections." }` | **201 Created** with route. **400 Bad Request** for invalid data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not authorised. **404 Not Found** if event does not exist. **409 Conflict** if the event already has a route. **500 Internal Server Error** for unexpected errors. |

---

## 7.3 Update Event Route

| HTTP Method | Route                         | Description                              | Role Required | Request Body                                                                                                                                                                      | Expected Response                                                                                                                                                                                                                                                     |
| ----------- | ----------------------------- | ---------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PUT         | `/api/events/{eventId}/route` | Updates the route belonging to an event. | Organiser     | `{ "routeName": "Updated Peninsula 21K Route", "distanceKm": 21.1, "startPoint": "Green Point", "finishPoint": "Green Point", "routeInformation": "Updated route information." }` | **200 OK** with updated route. **400 Bad Request** for invalid data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not authorised. **404 Not Found** if event or route does not exist. **500 Internal Server Error** for unexpected errors. |

---

# 8. Category Endpoints

## 8.1 Get All Categories

| HTTP Method | Route             | Description                         | Role Required | Request Body | Expected Response                                                                   |
| ----------- | ----------------- | ----------------------------------- | ------------- | ------------ | ----------------------------------------------------------------------------------- |
| GET         | `/api/categories` | Returns available event categories. | Public        | None         | **200 OK** with category list. **500 Internal Server Error** for unexpected errors. |

---

## 8.2 Get Categories for an Event

| HTTP Method | Route                              | Description                                           | Role Required | Request Body | Expected Response                                                                                                              |
| ----------- | ---------------------------------- | ----------------------------------------------------- | ------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| GET         | `/api/events/{eventId}/categories` | Returns all categories belonging to a specific event. | Public        | None         | **200 OK** with category list. **404 Not Found** if event does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 8.3 Create Category

| HTTP Method | Route                              | Description                          | Role Required | Request Body                                                                                              | Expected Response                                                                                                                                                                                                                                                                                                       |
| ----------- | ---------------------------------- | ------------------------------------ | ------------- | --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/events/{eventId}/categories` | Creates a new category for an event. | Organiser     | `{ "categoryName": "21.1 km Open", "distanceKm": 21.1, "maximumParticipants": 1000, "entryFee": 250.00 }` | **201 Created** with category. **400 Bad Request** for invalid data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not authorised. **404 Not Found** if event does not exist. **409 Conflict** if category already exists for the event. **500 Internal Server Error** for unexpected errors. |

---

## 8.4 Update Category

| HTTP Method | Route                          | Description                         | Role Required | Request Body                                                                                              | Expected Response                                                                                                                                                                                                                                                                                                                                 |
| ----------- | ------------------------------ | ----------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PUT         | `/api/categories/{categoryId}` | Updates an existing event category. | Organiser     | `{ "categoryName": "21.1 km Open", "distanceKm": 21.1, "maximumParticipants": 1200, "entryFee": 275.00 }` | **200 OK** with updated category. **400 Bad Request** for invalid data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not authorised. **404 Not Found** if category does not exist. **409 Conflict** if the new category name conflicts with an existing category. **500 Internal Server Error** for unexpected errors. |

---

## 8.5 Delete Category

| HTTP Method | Route                          | Description                         | Role Required | Request Body | Expected Response                                                                                                                                                                                                                                                                                  |
| ----------- | ------------------------------ | ----------------------------------- | ------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DELETE      | `/api/categories/{categoryId}` | Deletes an existing event category. | Organiser     | None         | **204 No Content** when successfully deleted. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not authorised. **404 Not Found** if category does not exist. **409 Conflict** if the category has existing enrolments. **500 Internal Server Error** for unexpected errors. |

---

# 9. Enrolment Endpoints

## 9.1 Enrol in an Event

| HTTP Method | Route                              | Description                                                                 | Role Required | Request Body          | Expected Response                                                                                                                                                                                                                                                                                                                                                             |
| ----------- | ---------------------------------- | --------------------------------------------------------------------------- | ------------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/events/{eventId}/enrolments` | Registers the authenticated Participant for an event and selected category. | Participant   | `{ "categoryId": 1 }` | **201 Created** with enrolment details. **400 Bad Request** for invalid category information. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not a Participant. **404 Not Found** if event or category does not exist. **409 Conflict** if participant is already enrolled or category is full. **500 Internal Server Error** for unexpected errors. |

### Example successful response

```json
{
  "enrolmentId": 1,
  "participantId": 3,
  "eventId": 1,
  "categoryId": 1,
  "status": "Confirmed"
}
```

---

## 9.2 Get My Enrolments

| HTTP Method | Route                | Description                                                        | Role Required | Request Body | Expected Response                                                                                                           |
| ----------- | -------------------- | ------------------------------------------------------------------ | ------------- | ------------ | --------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/enrolments/me` | Returns all enrolments belonging to the authenticated Participant. | Participant   | None         | **200 OK** with enrolments. **401 Unauthorized** if not authenticated. **500 Internal Server Error** for unexpected errors. |

---

## 9.3 Get Event Enrolments

| HTTP Method | Route                              | Description                                        | Role Required | Request Body | Expected Response                                                                                                                                                                                                                    |
| ----------- | ---------------------------------- | -------------------------------------------------- | ------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| GET         | `/api/events/{eventId}/enrolments` | Returns participants enrolled in a specific event. | Organiser     | None         | **200 OK** with enrolment list. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not an authorised Organiser. **404 Not Found** if event does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 9.4 Cancel Enrolment

| HTTP Method | Route                           | Description                                | Role Required | Request Body | Expected Response                                                                                                                                                                                                                                                                                                                         |
| ----------- | ------------------------------- | ------------------------------------------ | ------------- | ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DELETE      | `/api/enrolments/{enrolmentId}` | Cancels an existing Participant enrolment. | Participant   | None         | **204 No Content** when cancelled. **401 Unauthorized** if not authenticated. **403 Forbidden** if enrolment does not belong to the Participant. **404 Not Found** if enrolment does not exist. **409 Conflict** if the enrolment cannot be cancelled because of its current status. **500 Internal Server Error** for unexpected errors. |

---

# 10. Result Endpoints

## 10.1 Create Result

| HTTP Method | Route                           | Description                                                 | Role Required | Request Body                                                                                       | Expected Response                                                                                                                                                                                                                                                                                                                                          |
| ----------- | ------------------------------- | ----------------------------------------------------------- | ------------- | -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST        | `/api/events/{eventId}/results` | Records the result of a participant who completed an event. | Organiser     | `{ "enrolmentId": 1, "finishPosition": 12, "finishTime": "01:48:32", "resultStatus": "Finished" }` | **201 Created** with result. **400 Bad Request** for invalid result data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not an authorised Organiser. **404 Not Found** if event or enrolment does not exist. **409 Conflict** if a result already exists for the enrolment. **500 Internal Server Error** for unexpected errors. |

---

## 10.2 Get My Results

| HTTP Method | Route             | Description                                                 | Role Required | Request Body | Expected Response                                                                                                                    |
| ----------- | ----------------- | ----------------------------------------------------------- | ------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| GET         | `/api/results/me` | Returns results belonging to the authenticated Participant. | Participant   | None         | **200 OK** with participant results. **401 Unauthorized** if not authenticated. **500 Internal Server Error** for unexpected errors. |

---

## 10.3 Get Event Results

| HTTP Method | Route                           | Description                                           | Role Required | Request Body | Expected Response                                                                                                                                                                                                                   |
| ----------- | ------------------------------- | ----------------------------------------------------- | ------------- | ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET         | `/api/events/{eventId}/results` | Returns results for participants in a specific event. | Organiser     | None         | **200 OK** with event results. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not an authorised Organiser. **404 Not Found** if event does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 10.4 Update Result

| HTTP Method | Route                     | Description                             | Role Required | Request Body                                                                     | Expected Response                                                                                                                                                                                                                                                           |
| ----------- | ------------------------- | --------------------------------------- | ------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PUT         | `/api/results/{resultId}` | Updates an existing participant result. | Organiser     | `{ "finishPosition": 10, "finishTime": "01:45:20", "resultStatus": "Finished" }` | **200 OK** with updated result. **400 Bad Request** for invalid data. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not an authorised Organiser. **404 Not Found** if result does not exist. **500 Internal Server Error** for unexpected errors. |

---

## 10.5 Delete Result

| HTTP Method | Route                     | Description                             | Role Required | Request Body | Expected Response                                                                                                                                                                                                                                   |
| ----------- | ------------------------- | --------------------------------------- | ------------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DELETE      | `/api/results/{resultId}` | Deletes an existing participant result. | Organiser     | None         | **204 No Content** when successfully deleted. **401 Unauthorized** if not authenticated. **403 Forbidden** if user is not an authorised Organiser. **404 Not Found** if result does not exist. **500 Internal Server Error** for unexpected errors. |

---

# 11. Endpoint Summary

| Area           | Method | Route                              | Main Role               |
| -------------- | ------ | ---------------------------------- | ----------------------- |
| Authentication | POST   | `/api/auth/register`               | Public                  |
| Authentication | POST   | `/api/auth/login`                  | Public                  |
| Profile        | GET    | `/api/users/me`                    | Organiser / Participant |
| Profile        | PUT    | `/api/users/me`                    | Organiser / Participant |
| Events         | GET    | `/api/events`                      | Public                  |
| Events         | GET    | `/api/events/{eventId}`            | Public                  |
| Events         | POST   | `/api/events`                      | Organiser               |
| Events         | PUT    | `/api/events/{eventId}`            | Organiser               |
| Events         | DELETE | `/api/events/{eventId}`            | Organiser               |
| Routes         | GET    | `/api/events/{eventId}/route`      | Public                  |
| Routes         | POST   | `/api/events/{eventId}/route`      | Organiser               |
| Routes         | PUT    | `/api/events/{eventId}/route`      | Organiser               |
| Categories     | GET    | `/api/categories`                  | Public                  |
| Categories     | GET    | `/api/events/{eventId}/categories` | Public                  |
| Categories     | POST   | `/api/events/{eventId}/categories` | Organiser               |
| Categories     | PUT    | `/api/categories/{categoryId}`     | Organiser               |
| Categories     | DELETE | `/api/categories/{categoryId}`     | Organiser               |
| Enrolments     | POST   | `/api/events/{eventId}/enrolments` | Participant             |
| Enrolments     | GET    | `/api/enrolments/me`               | Participant             |
| Enrolments     | GET    | `/api/events/{eventId}/enrolments` | Organiser               |
| Enrolments     | DELETE | `/api/enrolments/{enrolmentId}`    | Participant             |
| Results        | POST   | `/api/events/{eventId}/results`    | Organiser               |
| Results        | GET    | `/api/results/me`                  | Participant             |
| Results        | GET    | `/api/events/{eventId}/results`    | Organiser               |
| Results        | PUT    | `/api/results/{resultId}`          | Organiser               |
| Results        | DELETE | `/api/results/{resultId}`          | Organiser               |

---

# 12. Relationship Between API and Database

The API endpoint design corresponds to the database entities in the RaceDay ERD and SQL script.

| Database Entity | API Area                   |
| --------------- | -------------------------- |
| Users           | Authentication and Profile |
| Events          | Event Management           |
| Routes          | Route Management           |
| Categories      | Category Management        |
| Enrolments      | Participant Enrolment      |
| Results         | Result Management          |

The endpoint plan is intended to provide the API structure that will be implemented in the later development stage of the project.

---

# 13. Security and Authorisation

Authentication will be required for protected endpoints.

Organiser-only operations will reject Participants with:

```text
403 Forbidden
```

Unauthenticated requests to protected endpoints will return:

```text
401 Unauthorized
```

Participants will only be able to access and manage their own enrolments and personal results.

Organisers will be able to manage events and view enrolments and results according to their permissions.

Passwords will not be returned in API responses.

---

# 14. Validation Rules

The API should validate incoming data before creating or updating database records.

Examples include:

* Email addresses must be unique.
* Required fields cannot be empty.
* Event types must be Running, Walking or Cycling.
* Category distances must be greater than zero.
* Entry fees cannot be negative.
* Maximum participant limits must be greater than zero when provided.
* Enrolment status must be Pending, Confirmed or Cancelled.
* Result status must be Finished, DNF or DNS.
* Finish positions must be greater than zero when provided.
* A participant cannot enrol in the same event more than once.
* An enrolment can have no more than one result.
* A category cannot be duplicated within the same event.

---

# 15. Part 1 Design Decision

The endpoint plan is designed before API implementation so that the database, ERD and API structure remain consistent.

The API uses resource-based routes such as:

```text
/api/events
/api/categories
/api/enrolments
/api/results
```

Specific resources are identified using IDs, for example:

```text
/api/events/{eventId}
/api/categories/{categoryId}
/api/enrolments/{enrolmentId}
/api/results/{resultId}
```

This structure provides a clear separation between authentication, event management, participant enrolment and result management.

