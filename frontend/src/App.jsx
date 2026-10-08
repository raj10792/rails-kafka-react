import { useEffect, useState } from "react";
import {
  getOrders,
  createOrder
} from "./api";

function App() {

  const [orders, setOrders] = useState([]);

  const [form, setForm] = useState({
    customer_name: "",
    product_name: "",
    quantity: 1,
    amount: ""
  });

  const loadOrders = async () => {

    try {

      const data = await getOrders();

      setOrders(data);

    } catch (error) {

      console.error(error);

    }
  };

  useEffect(() => {

    loadOrders();

  }, []);

  const handleChange = (event) => {

    setForm({
      ...form,
      [event.target.name]:
        event.target.value
    });

  };

  const handleSubmit = async (event) => {

    event.preventDefault();

    try {

      await createOrder(form);

      setForm({
        customer_name: "",
        product_name: "",
        quantity: 1,
        amount: ""
      });

      await loadOrders();

    } catch (error) {

      alert(error.message);

    }

  };

  return (
    <div style={{
      maxWidth: "900px",
      margin: "40px auto",
      fontFamily: "Arial"
    }}>

      <h1>Kafka Order System</h1>

      <h2>Create Order</h2>

      <form onSubmit={handleSubmit}>

        <input
          name="customer_name"
          placeholder="Customer name"
          value={form.customer_name}
          onChange={handleChange}
        />

        <br /><br />

        <input
          name="product_name"
          placeholder="Product name"
          value={form.product_name}
          onChange={handleChange}
        />

        <br /><br />

        <input
          name="quantity"
          type="number"
          min="1"
          value={form.quantity}
          onChange={handleChange}
        />

        <br /><br />

        <input
          name="amount"
          type="number"
          placeholder="Amount"
          value={form.amount}
          onChange={handleChange}
        />

        <br /><br />

        <button type="submit">
          Place Order
        </button>

      </form>

      <hr />

      <h2>Orders</h2>

      <table
        border="1"
        cellPadding="10"
        width="100%"
      >

        <thead>

          <tr>
            <th>ID</th>
            <th>Customer</th>
            <th>Product</th>
            <th>Quantity</th>
            <th>Amount</th>
            <th>Status</th>
          </tr>

        </thead>

        <tbody>

          {orders.map((order) => (

            <tr key={order.id}>

              <td>{order.id}</td>

              <td>
                {order.customer_name}
              </td>

              <td>
                {order.product_name}
              </td>

              <td>
                {order.quantity}
              </td>

              <td>
                ₹{order.amount}
              </td>

              <td>
                {order.status}
              </td>

            </tr>

          ))}

        </tbody>

      </table>

    </div>
  );
}

export default App;