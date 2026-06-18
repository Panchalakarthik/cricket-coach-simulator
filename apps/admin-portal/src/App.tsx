import { LoginPage } from "@/features/auth/login-page";

const token = localStorage.getItem("token");

export function App() {
  if (!token) return <LoginPage />;
  return (
    <main style={{ padding: 24, fontFamily: "system-ui" }}>
      <h1>Cricket Coach Simulator — Admin Portal</h1>
      <p>Authenticated. Feature pages coming in subsequent plans.</p>
    </main>
  );
}
