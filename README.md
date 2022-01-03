# UPDATE SFDX PACKAGE VERSION

Update package version in `sfdx-project.json`

A GitHub action that updates package version on the sfdx-project.json file.

## Inputs

| name          | required | type   | default   | description                                                                                                              |
| ------------- | -------- | ------ | --------- | ------------------------------------------------------------------------------------------------------------------------ |
| package-names | yes      | string |           | Package names defined in sfdx-project.json. Pass which packages you want to increase the version. Use spacing in between |
| upgrade-type  | yes      | string | `"PATCH"` | Type of upgrade to the package. `"MAJOR"`,`"MINOR"`,`"PATCH"`                                                            |

## Example

```yml
name: Increase SFDX Package Version
on: [push]
jobs:
  increase_package_version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/sfdx-package-version-updater@v1.0
        with:
          package-names: "my-awesome-sfdx-package my-second-awesome-sfdx-package" # your package names
          upgrade-type: "MAJOR" # upgrade type
      - name: Push Changes
        run: |
          git config user.name github-actions
          git config user.email github-actions@github.com
          git add .
          git commit -m "Increase Package Version"
          git push
```
