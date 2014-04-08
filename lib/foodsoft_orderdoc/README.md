FoodsoftOrderdoc
================

Replaces CSV spreadsheet download with supplier-sent one, when available.
Works together with sharedlists, it only makes sense for shared suppliers.

This plugin requires OpenOffice.org to be installed, as well as a macro.
Copy the file `Module1.xba` to `~/.config/libreoffice/4/user/basic/Standard/Module1.xba`
and you're set.

When not using absolute paths in the sharedlists article database, you may
want to set the supplier\_assets path in `config/app_config.yml`:
```yaml
  # Search path for supplier templates used for ordering.
  shared_supplier_assets_path: /apps/sharedlists/shared/supplier_assets
```
