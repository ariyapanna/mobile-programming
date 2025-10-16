module.exports = async () => {
    const { Sequelize } = require('sequelize');

    const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASS, {
        host: process.env.DB_HOST,
        dialect: 'mysql',
        define: {
            timestamps: true,
            underscored: true
        },
        logging: false
    });

    const models = {
        Account: require('../models/Account')(sequelize),
    };

    try
    {
        await sequelize.authenticate();
        console.log('[Database] Connection has been established successfully.');

        await sequelize.sync();
        return models;
    }
    catch(e)
    {
        throw new Error(`[Database] An error occurred while connecting to the database (${e.message}).`);
    }
}