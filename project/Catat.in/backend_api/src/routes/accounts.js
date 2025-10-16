const router = require('express').Router();
const { index, create } = require('../controllers/accountController');

module.exports = () => {
    router.get('/', index);
    router.post('/', create);

    return router;
}