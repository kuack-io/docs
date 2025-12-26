# Kuack Documentation

This repository contains the source of truth for the Kuack project documentation. The content here is treated as "Documentation as Code" and is consumed by the main website to generate the static documentation site.

## How it Works

The documentation is stored in the `public/` directory, organized by version (e.g., `public/1.x/`). The website fetches these Markdown files and renders them.

Two manifest layers describe what gets published:

1. `public/manifest.json` enumerates every available documentation version. Each entry has a `value` such as `"1.x"` and a `label` used in the site version picker. Adding a new version starts here.
2. `public/<version>/manifest.json` defines the navigation tree (sidebar) for that specific version. This is the file you edit when you add or rearrange individual documents.

## Contributing to Documentation

### Adding a New Document

1. **Create the File**: Add your new Markdown (`.md`) file in the appropriate version directory (e.g., `public/1.x/my-new-doc.md`). You can also create subdirectories to organize files (e.g., `public/1.x/guides/my-guide.md`).

2. **Register in Manifest**: Open `public/1.x/manifest.json` and add an entry for your new file.

   ```json
   {
     "id": "my-new-doc",
     "title": "My New Document",
     "path": "/docs/latest/my-new-doc.md"
   }
   ```

   - `id`: A unique identifier for the document.
   - `title`: The text that will appear in the sidebar navigation.
   - `path`: The path to the file. Note that for the latest version, we typically use `/docs/latest/...` in the path, which the website resolves to the correct version.

### Creating Nested Sections

You can create collapsible sections in the sidebar by using the `children` property in the manifest. This allows for infinite nesting depth.

**Example of a nested structure:**

```json
{
  "id": "advanced-guides",
  "title": "Advanced Guides",
  "children": [
    {
      "id": "scaling",
      "title": "Scaling",
      "path": "/docs/latest/guides/scaling.md"
    },
    {
      "id": "security",
      "title": "Security",
      "children": [
        {
          "id": "auth",
          "title": "Authentication",
          "path": "/docs/latest/guides/security/auth.md"
        }
      ]
    }
  ]
}
```

### Writing Guidelines

- **Format**: We use standard Markdown.
- **Style**: Keep the tone technical but accessible.
- **Linting**: This repository uses `markdownlint` to ensure consistent formatting. If your PR fails the check, it's likely due to a formatting issue (e.g., headers, lists).
