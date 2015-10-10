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

### More thoughts

The package `factual.core` will use the provided hooks and generate
the debian package based on that. The hooks will basically have a
package instance passed to them, or an abstraction of some kind.

The package `factual` provides an abstraction over hooks, as in
functions like `ensure-package-exists` (not sure yet how to do
this... should it be `(defmethod ensure ((type :package)
&allow-other-keys))` or something similar?), that the facts will
usually use.

The facts shouldn't have to use the low-level hooks. The `factual`
package should provide everything necessary.
