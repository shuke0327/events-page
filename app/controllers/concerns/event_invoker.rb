class EventInvoker
  def cancel_order_successful(order_id)
    order = Order.find_by_id(order_id)

    # notify someone ...    
  end
end