import { useState } from "react";
import { api } from "@/lib/api";

export function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      const { data } = await api.post("/auth/login", { email, password });
      localStorage.setItem("token", data.token);
      window.location.href = "/";
    } catch {
      setError("Invalid credentials");
    } finally {
      setLoading(false);
    }
  }

  return (
    <main style={{ maxWidth: 400, margin: "10vh auto", padding: 24, fontFamily: "system-ui" }}>
      <h1 style={{ marginBottom: 24 }}>Cricket Coach Simulator</h1>
      <h2 style={{ marginBottom: 16, fontWeight: 500 }}>Admin Login</h2>
      <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: 12 }}>
        <label>
          Email
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            style={{ display: "block", width: "100%", padding: 8, marginTop: 4 }}
          />
        </label>
        <label>
          Password
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            style={{ display: "block", width: "100%", padding: 8, marginTop: 4 }}
          />
        </label>
        {error && <p style={{ color: "red", margin: 0 }}>{error}</p>}
        <button type="submit" disabled={loading} style={{ padding: "10px 16px", cursor: "pointer" }}>
          {loading ? "Logging in…" : "Login"}
        </button>
      </form>
    </main>
  );
}
