const router = require('express').Router();

module.exports = () => {
    router.use('/accounts', require('./accounts')());
    return router;
}