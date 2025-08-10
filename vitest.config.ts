import { defineConfig } from 'vitest/config';
import tsconfigPaths from 'vite-tsconfig-paths';
import swc from 'unplugin-swc';

export default defineConfig({
  plugins: [
    tsconfigPaths(),
    (swc as any).vite({
      jsc: {
        target: 'es2021',
        parser: { syntax: 'typescript', decorators: true },
        transform: { decoratorMetadata: true },
      },
      module: { type: 'commonjs' },
    }),
  ],
  test: {
    environment: 'node',
    include: [
      'src/**/*.spec.ts',
      'test/**/*.spec.ts',
      'test/**/*.{e2e,e2e-spec}.ts',
    ],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
    },
  },
});
