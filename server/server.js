// Lumico todo RESTful node.js server by Dan Berry
// ~A stateless, uniform, on-demand, URI-based data source~

// Using express as it's the standard server framework for node.js
var express = require("express")
var app = express()

// Import file to handle the local sqlite database
var db = require("./database.js")

// bodyParses parses POST requests and stores them in req.body within an endpoint
var bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Server port
var HTTP_PORT = 8000
var ADDRESS = '0.0.0.0'

// Initialise server, listening on HTTP_PORT
app.listen(HTTP_PORT, ADDRESS, () => {
    console.log("Server running on port %PORT%".replace("%PORT%", HTTP_PORT))
});

// Root endpoint
app.get("/", (req, res, next) => {
    res.json({ "message": "Ok" })
});

// Endpoint to get all tasks
app.get("/api/tasks", (req, res, next) => {
    var query = "SELECT * FROM tasks"
    var params = []
    db.all(query, params, (err, rows) => {
        if (err) {
            // Throw a bad request error since something went wrong retreiving data
            res.status(400).json({ "error": err.message });
            return;
        }
        // Return all of the tasks (rows) in json format
        res.json({
            "message": "success",
            "data": rows
        })
    });
});

// Endpoint to get a single task by id, specified with ':id'
app.get("/api/task/:id", (req, res, next) => {
    var query = "SELECT * FROM tasks WHERE id = ?"
    var params = [req.params.id]
    db.get(query, params, (err, row) => {
        if (err) {
            res.status(400).json({ "error": err.message });
            return;
        }
        // Return the task (row) in json format
        res.json({
            "message": "success",
            "data": row
        })
    });
});

// Endpoint to mark a task as completed
app.post("/api/task/:id/complete", (req, res, next) => {
    var query = 'UPDATE tasks SET completed=1 WHERE id = ?'
    var params = [req.params.id]
    var data = {
        id: req.params.id,
        completed: 1
    }
    //ES6 arrow notation isn't used below as we need to use 'this' when returning lastID
    db.run(query, params, function (err, result) {
        if (err) {
            res.status(400).json({ "error": err.message })
            return;
        }
        // Return the id of the created task as confirmation in json format
        res.json({
            "message": "success",
            "data": data
        })
    });
})

// Endpoint to mark a task as uncompleted
app.post("/api/task/:id/incomplete", (req, res, next) => {
    var query = 'UPDATE tasks SET completed=0 WHERE id = ?'
    var params = [req.params.id]
    var data = {
        id: req.params.id,
        completed: 0
    }
    //ES6 arrow notation isn't used below as we need to use 'this' when returning lastID
    db.run(query, params, function (err, result) {
        if (err) {
            res.status(400).json({ "error": err.message })
            return;
        }
        // Return the id of the created task as confirmation in json format
        res.json({
            "message": "success",
            "data": data
        })
    });
})

// Endpoint to create a new task
app.post("/api/task/", (req, res, next) => {
    var errors = []
    // Check if the body, created by 'body-parser', contains a task
    if (!req.body.task) {
        errors.push("No task specified");
    }
    // Throw a bad request error if an error (likely the above) is encountered
    if (errors.length) {
        res.status(400).json({ "error": errors.join(",") });
        return;
    }
    // Parse the task into a data object
    var data = {
        task: req.body.task,
        completed: 0
    }
    var query = 'INSERT INTO tasks (task, completed) VALUES (?1, ?2)'
    var params = [data.task, data.completed]

    //ES6 arrow notation isn't used below as we need to use 'this' when returning lastID
    db.run(query, params, function (err, result) {
        if (err) {
            res.status(400).json({ "error": err.message })
            return;
        }
        // Return the id of the created task as confirmation in json format
        res.json({
            "message": "success",
            "data": data,
            "id": this.lastID
        })
    });
})

// Create endpoint to delete a task
app.delete("/api/task/:id", (req, res, next) => {
    db.run(
        'DELETE FROM tasks WHERE id = ?',
        // Get the id of the task to delete from the request parameters
        req.params.id,
        function (err, _) {
            if (err) {
                res.status(400).json({ "error": res.message })
                return;
            }
            res.json({ "message": "deleted", changes: this.changes })
        });
})

// Throw a not found error for any other requests
app.use(function (req, res) {
    res.status(404);
});