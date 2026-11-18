package main

import (
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
)

func (r *Repository) LockOrder(tx *gorm.DB, orderID int64) (*Order, error) {
	var order Order

	result := tx.Raw(`
        SELECT *
        FROM orders
        WHERE id = ?
        FOR UPDATE
    `, orderID).Scan(&order)

	if result.Error != nil {
		return nil, result.Error
	}

	if result.RowsAffected == 0 {
		return nil, ErrOrderNotFound // 这属于业务类型失败而非数据库层面的失败！单独处理！
	}

	return &order, nil
}

func (r *Repository) GetOrderTotal(tx *gorm.DB, orderID int64) (decimal.Decimal, error) {
	var total decimal.Decimal

	result := tx.Raw(`
        SELECT SUM(quantity * unit_price)
        FROM order_items
        WHERE order_id = ?
    `, orderID).Scan(&total)

	if result.Error != nil {
		return 0, result.Error
	}

	return total, nil
}

func (r *Repository) CreatePayment(tx *gorm.DB, payment *Payment) error {
	return tx.Create(payment).Error
}
