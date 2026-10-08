const API_URL = "http://localhost:3000/api";

export async function getOrders() {
  const response = await fetch(`${API_URL}/orders`);

  if (!response.ok) {
    throw new Error("Failed to load orders");
  }

  return response.json();
}

export async function createOrder(order) {
  const response = await fetch(`${API_URL}/orders`, {
    method: "POST",

    headers: {
      "Content-Type": "application/json"
    },

    body: JSON.stringify(order)
  });

  if (!response.ok) {
    throw new Error("Failed to create order");
  }

  return response.json();
}