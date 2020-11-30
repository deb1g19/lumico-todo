var sqlite3 = require('sqlite3').verbose()
var md5 = require('md5')

const DBSOURCE = "db.sqlite"

let db = new sqlite3.Database(DBSOURCE, (err) => {
    if (err) {
        // Cannot open database
        console.error(err.message)
        throw err
    } else {
        console.log('Connected to the SQLite database.')
        db.run(`CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task text
            )`,
            (err) => {
                if (err) {
                    // The tasks table already exists. We don't need to do anything
                }
            });
    }
});


module.exports = db