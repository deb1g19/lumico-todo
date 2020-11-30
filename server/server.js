// Lumico todo RESTful node.js server by Dan Berry
// ~A stateless, uniform, on-demand, URI-based data source~

// Using express as it's the standard server framework for node.js
var express = require("express")
var app = express()
// Import file to handle the local sqlite database
var db = require("./database.js")

// Server port
var HTTP_PORT = 8000
// Initialise server, listening on HTTP_PORT
app.listen(HTTP_PORT, () => {
    console.log("Server running on port %PORT%".replace("%PORT%", HTTP_PORT))
});

// Root endpoint
app.get("/", (req, res, next) => {
    res.json({ "message": "Ok" })
});

// Endpoint to get all tasks
app.get("/api/tasks", (req, res, next) => {
    var sql = "select * from tasks"
    var params = []
    db.all(sql, params, (err, rows) => {
        if (err) {
            // Throw a 'bad request' error since something went wrong retreiving data
            res.status(400).json({ "error": err.message });
            return;
        }
        res.json({
            "message": "success",
            "data": rows
        })
    });
});

// Endpoint to get al single task by id
app.get("/api/user/:id", (req, res, next) => {
    var sql = "select * from user where id = ?"
    var params = [req.params.id]
    db.get(sql, params, (err, row) => {
        if (err) {
            res.status(400).json({ "error": err.message });
            return;
        }
        res.json({
            "message": "success",
            "data": row
        })
    });
});
// TODO: Insert endpoints here

// Throw a '404 not found' error for any other requests
app.use(function (req, res) {
    res.status(404);
});