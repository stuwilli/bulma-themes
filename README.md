# bulma-themes

Bulma Theme Generator, project is a fork of @m-kutnik excellent project.

The original project was a few years old when I came across it and had lots of dependency issues building on an up-to-date environment. To workaround that, I Dockerised the project using an older version of Node, therefore this should not be used on any production environments.

The only other change I have made was to remove the dependency on the backend service and instead generate a .scss file with all necessary variables and imports. This was sufficient for my use case where the .scss file is consumed in another project with its own build process, rather than a complete compiled bundle.
