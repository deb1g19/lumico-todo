var sqlite3 = require('sqlite3').verbose()

// The name of the local database file
const DBSOURCE = "db.sqlite"

let db = new sqlite3.Database(DBSOURCE, (err) => {
    if (err) {
        // This error is thrown if the database cannot be opened
        console.error(err.message)
        throw err
    } else {
        console.log('Connected to the database successfully')
        // There's a single table, with an id column and a task (text) column for tasks
        db.run(`CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task TEXT,
            completed INTEGER
            )`,
            (err) => {
                if(err) {
                    // The table has already been created. We don't need to do anything here
                } else {
                    var insert = 'INSERT INTO tasks (task, completed) VALUES (?,?)'
                    db.run(insert, ["Tap anywhere on a task to mark it as completed",0])
                    db.run(insert, ["Swipe a task left or right to delete it",0])
                }
            });
    }
});

// Create a binding to the above function for use in other files
module.exports = db