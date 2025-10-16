const { DataTypes, Model } = require('sequelize');

module.exports = (sequelize) => {
    class Account extends Model {}

    Account.init(
        {
            id: {
                type: DataTypes.UUID,
                defaultValue: DataTypes.UUIDV4,
                primaryKey: true
            },
            code: {
                type: DataTypes.STRING,
                allowNull: false,
                unique: true
            },
            name: {
                type: DataTypes.STRING,
                allowNull: false
            },
            type: {
                type: DataTypes.ENUM(['Assets', 'Liabilities', 'Equity', 'Revenue', 'Expenses']),
                allowNull: false
            },
            normalBalance: {
                type: DataTypes.ENUM(['Debit', 'Credit']),
                allowNull: false
            }
        },
        {
            sequelize
        }
    )

    return Account;
}