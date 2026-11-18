package main

import "errors"

var (
	ErrOrderNotFound        = errors.New("order not found")
	ErrOrderNotPending      = errors.New("order is not pending")
	ErrInvalidPaymentAmount = errors.New("invalid payment amount")
)
