# factual

For each node, create a debian package applying all the facts defined
in the yaml file.

## How it works

Based on [deb-packager](https://github.com/ralt/deb-packager).

For each yaml file in nodes/:
- Load each fact package defined in the `facts` key
- Assign each variable defined in the node to the fact's variables
  (either single values, lists or property lists)
- Run each hook available in the fact's package

The hooks:

- `add-dependency`
- `add-data-file`
- `add-control-file`

A "standard library" will be provided to make common things easy.
