function dbInit() {
    let db = LocalStorage.openDatabaseSync("sonegx_player", "", "Player database", 1000000)
    try {
        db.transaction(function (tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS library (name TEXT, path TEXT, videosN INTEGER)')
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("sonegx_player", "", "Player database", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function dbInsert(name, path, videosN) {
    let db = dbGetHandle()
    let rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO library VALUES(?, ?, ?)', [name, path, videosN])
        let result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

function dbReadAll() {
    let db = dbGetHandle()
    db.transaction(function (tx) {
        let results = tx.executeSql('SELECT name, path, videosN FROM library')
        for (let i = 0; i < results.rows.length; i++) {
            loadedLibrary.push({
                name: results.rows.item(i).name,
                path: results.rows.item(i).path,
                videosN: results.rows.item(i).videosN
            })
        }
    })
}

function dbUpdate(name, path, videosN) {
    let db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('UPDATE library SET path = ?, videosN = ? WHERE name = ?', [path, videosN, name])
    })
}

function dbDeleteRow(name) {
    let db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('DELETE FROM library WHERE name = ?', [name])
    })
}
