const AppError = require('../errors/AppError');
const { HttpStatus } = require('../utils/apiResponse');

const AVAILABLE_TYPES = {
    1: 'Assets',
    2: 'Liabilities',
    3: 'Equity',
    4: 'Revenue',
    5: 'Expenses'
}

/**
 * Checks if a given normal balance is valid.
 * A normal balance is valid if it is either 'Debit' or 'Credit'.
 * @param {string} normalBalance The normal balance of the account.
 * @returns {boolean} True if the normal balance is valid, false otherwise.
 */
const isValidNormalBalance = (normalBalance) => {
    return (normalBalance === 'Debit' || normalBalance === 'Credit');
}

/**
 * Checks if a given code and type are valid.
 * A code and type are valid if the first character of the code matches one of the available types and the type matches the type associated with the code index.
 * @param {string} code The code of the account.
 * @param {string} type The type of the account.
 * @returns {boolean} True if the code and type are valid, false otherwise.
 */
const isValidCodeAndType = (code, type) => {
    const availableTypeKeys = Object.keys(AVAILABLE_TYPES);
    const codeIndex = code.charAt(0);

    return (!availableTypeKeys.includes(codeIndex) || (type === AVAILABLE_TYPES[codeIndex]));
}

/**
 * Retrieves all accounts from the database.
 * @returns {Promise} Promise containing an array of Account objects.
 * @throws {Error} If an error occurs while retrieving the accounts.
 */
const getAccounts = async () => {
    return await model.Account.findAll();
}

/**
 * Create a new account
 * @param {string} name The name of the account
 * @param {string} code The code of the account
 * @param {string} type The type of the account. It must be one of the following: Assets, Liabilities, Equity, Revenue, Expenses
 * @param {string} normalBalance The normal balance of the account. It must be Debit or Credit
 * @returns {Promise} Promise containing the newly created account
 * @throws {AppError} If the code already exists, code and type are not valid, or normal balance is not valid
 */
const createAccount = async (name, code, type, normalBalance) => {
    const isCodeExists = await model.Account.findOne({ where: { code } });
    if(isCodeExists)
        throw new AppError('Code already exists.', HttpStatus.CONFLICT);

    if(!isValidCodeAndType(code, type))
        throw new AppError('Code and type are not valid.', HttpStatus.BAD_REQUEST);

    if(!isValidNormalBalance(normalBalance))
        throw new AppError('Normal balance is not valid. It must be Debit or Credit.', HttpStatus.BAD_REQUEST);

    return await model.Account.create({ name, code, type, normalBalance });
}

module.exports = { getAccounts, createAccount };