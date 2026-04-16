import type { Metadata } from 'next';
import './globals.css';

/**
 * RAPTOR OS - Jurassic Park-themed Kiosk Interface
 * @see docs/KIOSK.md for full specification
 */
export const metadata: Metadata = {
  title: 'RAPTOR OS',
  description: 'Cyberdeck 2026 - Jurassic Park-themed kiosk interface',
  viewport: {
    width: 640,  // Fixed for 640x480 display
    initialScale: 1.0,
    maximumScale: 1.0,
    userScalable: false,
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <div className="app-container">
          <header className="app-header">
            {/* RAPTOR OS branding with JP aesthetic */}
            <h1>RAPTOR OS</h1>
          </header>
          <main className="app-main">
            {children}
          </main>
        </div>
      </body>
    </html>
  );
}
