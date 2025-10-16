const HttpStatus = {
    SUCCESS: 200,
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_SERVER_ERROR: 500
};

/**
 * Sends a successful response to the client.
 * @param {Response} res The response object.
 * @param {*} data The data to be sent in the response.
 * @param {Number} [code=HttpStatus.SUCCESS] The HTTP status code to use.
 * @returns {Response} The response object with the JSON data and status code set.
 */
const success = (res, data, code = HttpStatus.SUCCESS) => {
    return res.status(code).json({ status: 'success', data });
};

/**
 * Sends an error response to the client.
 * @param {Response} res The response object.
 * @param {string} message The error message to be sent in the response.
 * @param {Number} [code=HttpStatus.INTERNAL_SERVER_ERROR] The HTTP status code to use.
 * @returns {Response} The response object with the JSON data and status code set.
 */
const error = (res, message, code = HttpStatus.INTERNAL_SERVER_ERROR) => {
    return res.status(code).json({ status: 'error', message });
}

module.exports = { HttpStatus, success, error };