# tempus
an app to track time for auto repair shops. This app will have a backend in an undetermined language, an iOS app in Swift, and an Android app.


## Feature set

1. Admin/Backend
..* Database that contains all employees, and jobs
....* Employee should include name, time clocked in that day, time worked for that week, jobs done that day, and other imports from tracks
....* A Job should include: waiting for parts, done, employee, time started, time ended, customer, and other imports from tracks
..* A Status board that has an editable status for each job
....* The Status Board should have customer, time in, status (like waiting on parts, Work in Progress, or done), and Employee
..* API
....* Password protected? OAuth?
....* Endpoints for jobs for employee
....* Endpoints for employee efficiency
..* Reports
....* All employees with efficiency, jobs completed for the week, average hours per job, and hours worked for the week
....* Color Coded?
2. User/iOS/Android
..* Clock in/out
....* Geolocate auto clock in
....* normal clock in
....* clock out
..* stats page
....* Efficiency based on time expected / time taken
....* Hours clocked for the week
..* Assigned Jobs
....* Notification when a new job is assigned
....* See list of assigned jobs in a priority queue
....* Leads to current jobs page
..* Current Job
....* Punch in / Punch out per job
....* See details from tracks for the job
