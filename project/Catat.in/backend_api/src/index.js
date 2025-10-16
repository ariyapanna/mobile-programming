require('dotenv').config();

const express = require('express');
const cors = require('cors');

(async function() {
    const app = express();
    const port = process.env.PORT || 3000;

    app.use(cors());
    app.use(express.json());

    try
    {
        global.model = await require('./config/database')(); // Connect to the database and initialize the models

        app.get('/', (req, res) => res.send('Hello World'));
        app.use('/api', require('./routes')());
        app.listen(port, () => console.log(`[Server] Listening on port ${port}`));
    }
    catch(e)
    {
        console.error(e);
    }
})()