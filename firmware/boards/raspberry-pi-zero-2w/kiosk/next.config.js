/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  reactStrictMode: true,
  // Optimize for Pi Zero 2W (limited resources)
  experimental: {
    optimizeCss: true,
  },
  // Disable unnecessary features for kiosk
  compress: true,
  poweredByHeader: false,
  // Ensure proper standalone output
  outputFileTracingRoot: undefined,
};

module.exports = nextConfig;
