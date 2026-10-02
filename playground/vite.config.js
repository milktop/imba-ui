import { defineConfig } from 'vite'
import { compile } from 'imba/compiler'

// Same narrow Imba plugin as @milktop/inertia-imba/vite, minus the Inertia bits.
function imba() {
  return {
    name: 'imba',
    enforce: 'pre',
    config() {
      return {
        optimizeDeps: { include: ['imba', 'imba/runtime'] },
        resolve: { dedupe: ['imba'] },
      }
    },
    transform(source, id) {
      const filename = id.split('?')[0]
      // `?raw` imports (the playground's code toggles) are Vite's to serve as text.
      if (!filename.endsWith('.imba') || /[?&]raw\b/.test(id)) return null
      const result = compile(source, { sourcePath: filename, platform: 'browser', sourcemap: true })
      const errors = result.diagnostics.filter((d) => d.severity === 1)
      if (errors.length) this.error(errors.map((e) => e.message).join('\n'))
      return { code: result.js, map: result.sourcemap }
    },
  }
}

// One bundle is fine for a demo app.
export default defineConfig({ plugins: [imba()], build: { chunkSizeWarningLimit: 1500 } })
