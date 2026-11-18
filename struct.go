package main

import (
	"time"

	"github.com/shopspring/decimal"
)

type OrderStatus string

const (
	OrderPending   OrderStatus = "pending"
	OrderPaid      OrderStatus = "paid"
	OrderShipped   OrderStatus = "shipped"
	OrderCompleted OrderStatus = "completed"
	OrderCancelled OrderStatus = "cancelled"
)

type PaymentStatus string

const (
	PaymentPending   PaymentStatus = "pending"
	PaymentSucceeded PaymentStatus = "succeeded"
	PaymentFailed    PaymentStatus = "failed"
	PaymentRefunded  PaymentStatus = "refunded"
)

type Order struct {
	ID        int64
	UserID    int64
	Status    OrderStatus
	CreatedAt time.Time
}

type OrderItem struct {
	ID        int64
	OrderID   int64
	ProductID int64
	Quantity  int
	UnitPrice decimal.Decimal
}

type Payment struct {
	ID                int64
	OrderID           int64
	Amount            decimal.Decimal
	Status            PaymentStatus
	ProviderReference *string
	CreatedAt         time.Time
}
