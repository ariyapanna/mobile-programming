const AppError = require('../errors/AppError');
const { HttpStatus, success, error } = require('../utils/apiResponse');
const accountService = require('../services/account');

/**
 * Get all accounts
 * @param {Object} req Request object
 * @param {Object} res Response object
 * @returns {Promise} Promise containing the response
 * @throws {Error} If an error occurs while getting the accounts
 */
const index = async (req, res) => {
    try
    {
        const accounts = await accountService.getAccounts();
        return success(res, accounts);
    }
    catch(e)
    {
        return error(res, 'An unexpected error occurred.');
    }
}

/**
 * Create a new account
 * @param {Object} req Request object
 * @param {Object} res Response object
 * @returns {Promise} Promise containing the response
 * @throws {Error} If any of the required fields are missing
 */
const create = async (req, res) => {
    try
    {
        const fields = ['name', 'code', 'type', 'normalBalance'];
        const missingFields = [];

        for(const field of fields)
        {
            if(!req.body[field])
                missingFields.push(field);
        }

        if(missingFields.length > 0)
            return error(res, `Missing fields: ${missingFields.join(', ')}`, HttpStatus.BAD_REQUEST);

        const { name, code, type, normalBalance } = req.body;
        const account = await accountService.createAccount(name, code, type, normalBalance);

        return success(res, account);
    }
    catch(e)
    {
        if(e instanceof AppError && e.statusCode !== HttpStatus.INTERNAL_SERVER_ERROR)
            return error(res, e.message, e.statusCode);

        return error(res, 'An unexpected error occurred.');
    }
}

module.exports = { index, create };