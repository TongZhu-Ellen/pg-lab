



func (s *Service) PayOrder(ctx context.Context, orderID int64, amount decimal.Decimal) error {
	return s.repo.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error { // 这里Trasn的意思是尝试执行里面的这个大的函数，如果不行则rollback
		order, err := s.repo.LockOrder(tx, orderID)
		if err != nil {
			return err
		}

		if order.Status != OrderPending {
			return ErrOrderNotPending
		}

		total, err := s.repo.GetOrderTotal(tx, orderID)
		if err != nil {
			return err
		}

		if !amount.GreaterThan(decimal.Zero) || !amount.Equal(total) {
			return ErrInvalidPaymentAmount
		}

		payment := &Payment{
			OrderID: orderID,
			Amount:  amount,
			Status:  PaymentSucceeded,
		}

		if err := s.repo.CreatePayment(tx, payment); err != nil {
			return err
		}

		return s.repo.MarkOrderPaid(tx, orderID)
	})
}