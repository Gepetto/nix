https://github.com/eclipse-cyclonedds/cyclonedds-python/commit/025c2708f9f25d25574e909ad7bada230e82be00 backported to 10.2

---
 cyclonedds/idl/__init__.py        |  6 ++++++
 cyclonedds/idl/_main.py           | 21 +++++++++++++++------
 cyclonedds/idl/_type_helper.py    | 17 ++++++++++++++++-
 cyclonedds/idl/_type_normalize.py |  6 ++++--
 cyclonedds/idl/annotations.py     |  3 ---
 5 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/cyclonedds/idl/__init__.py b/cyclonedds/idl/__init__.py
index f3b09c36..9b63d65e 100644
--- a/cyclonedds/idl/__init__.py
+++ b/cyclonedds/idl/__init__.py
@@ -45,6 +45,8 @@ def make_idl_struct(class_name: str, typename: str, fields: Dict[str, Any], *, d
     bases = tuple(list(bases) + [IdlStruct])
     namespace = IdlMeta.__prepare__(class_name, bases, typename=typename)

+    if "__annotations__" not in namespace:
+        namespace["__annotations__"] = {}
     for fieldname, _type in fields.items():
         namespace['__annotations__'][fieldname] = _type

@@ -183,6 +185,8 @@ def make_idl_union(class_name: str, typename: str, fields: Dict[str, ValidUnionH
         discriminator_is_key=discriminator_is_key
     )

+    if "__annotations__" not in namespace:
+        namespace["__annotations__"] = {}
     for fieldname, _type in fields.items():
         namespace['__annotations__'][fieldname] = _type

@@ -212,6 +216,8 @@ def make_idl_bitmask(class_name: str, typename: str, fields: Sequence[str], *, d

     namespace = IdlBitmaskMeta.__prepare__(class_name, (IdlBitmask,), typename=typename)

+    if "__annotations__" not in namespace:
+        namespace["__annotations__"] = {}
     for fieldname in fields:
         namespace['__annotations__'][fieldname] = bool

diff --git a/cyclonedds/idl/_main.py b/cyclonedds/idl/_main.py
index b889bda7..02787326 100644
--- a/cyclonedds/idl/_main.py
+++ b/cyclonedds/idl/_main.py
@@ -19,7 +19,7 @@
 from hashlib import md5

 from ._support import Buffer, Endianness, CdrKeyVmNamedJumpOp, KeyScanner, KeyScanResult
-from ._type_helper import get_origin, get_args, Annotated
+from ._type_helper import get_origin, get_args, Annotated, get_annotations
 from ._type_normalize import get_idl_annotations, get_idl_field_annotations, get_extended_type_hints
 from ._machinery import Machine

@@ -298,7 +298,6 @@ def __prepare__(metacls, __name: str, __bases: Tuple[type, ...], **kwds: Any) ->
             del kwds["typename"]

         namespace = super().__prepare__(__name, __bases, **kwds)
-        namespace["__annotations__"] = {}
         namespace["__idl_annotations__"] = {}
         namespace["__idl_field_annotations__"] = {}
         if typename:
@@ -317,6 +315,10 @@ def __new__(metacls, name, bases, namespace, **kwds):
         IDLNamespaceScope.exit()
         new_cls = super().__new__(metacls, name, bases, dict(**namespace))

+        unknown_members = list(new_cls.__idl_field_annotations__.keys() - get_annotations(new_cls))
+        if unknown_members:
+            raise TypeError(f"Members {unknown_members} for {name} not defined.")
+
         if "__idl_typename__" not in namespace:
             new_cls.__idl_typename__ = name

@@ -400,7 +402,6 @@ def __prepare__(metacls, __name: str, __bases: Tuple[type, ...], **kwds: Any) ->
         namespace = cast(Dict[str, Any], super().__prepare__(__name, __bases, **kwds))
         namespace["__idl_discriminator__"] = discriminator
         namespace["__idl_discriminator_is_key__"] = discriminator_is_key
-        namespace["__annotations__"] = {}
         namespace["__idl_annotations__"] = {}
         namespace["__idl_field_annotations__"] = {}
         IDLNamespaceScope.enter(namespace)
@@ -409,6 +410,11 @@ def __prepare__(metacls, __name: str, __bases: Tuple[type, ...], **kwds: Any) ->
     def __new__(metacls, name, bases, namespace, **kwds):
         IDLNamespaceScope.exit()
         new_cls = super().__new__(metacls, name, bases, dict(**namespace))
+
+        unknown_members = list(new_cls.__idl_field_annotations__.keys() - get_annotations(new_cls))
+        if unknown_members:
+            raise TypeError(f"Members {unknown_members} for {name} not defined.")
+
         if not len(bases):
             return new_cls

@@ -417,7 +423,7 @@ def __new__(metacls, name, bases, namespace, **kwds):
         names = set()

         # Use RAW annotations here because the type strings can maybe not be resolved yet
-        for name, _type in new_cls.__annotations__.items():
+        for name, _type in get_annotations(new_cls).items():
             if get_origin(_type) != Annotated and len(get_args(_type)) != 2:
                 raise TypeError(f"Fields of a union need to be case or default, '{name}: {_type}' is not.")
             if name in ['value', 'discriminator']:
@@ -470,7 +476,6 @@ def __prepare__(metacls, __name: str, __bases: Tuple[type, ...], **kwds: Any) ->
             del kwds["typename"]

         namespace = super().__prepare__(__name, __bases, **kwds)
-        namespace["__annotations__"] = {}
         namespace["__idl_annotations__"] = {}
         namespace["__idl_field_annotations__"] = {}
         IDLNamespaceScope.enter(namespace)
@@ -484,6 +489,10 @@ def __new__(metacls, name, bases, namespace, **kwds):
         IDLNamespaceScope.exit()
         new_cls = super().__new__(metacls, name, bases, dict(**namespace))

+        unknown_members = list(new_cls.__idl_field_annotations__.keys() - get_annotations(new_cls))
+        if unknown_members:
+            raise TypeError(f"Members {unknown_members} for {name} not defined.")
+
         if "__idl_typename__" not in namespace:
             new_cls.__idl_typename__ = name

diff --git a/cyclonedds/idl/_type_helper.py b/cyclonedds/idl/_type_helper.py
index 9fab0720..e5ee3abb 100644
--- a/cyclonedds/idl/_type_helper.py
+++ b/cyclonedds/idl/_type_helper.py
@@ -17,7 +17,22 @@
     raise NotImplementedError("This package cannot be used in Python version 3.8 or lower.")
 else:
     # We are in any Python 3.9 or 3.10 (maybe higher?) version
-    from typing import Annotated, get_origin, get_args, get_type_hints  # noqa F401
+    from typing import Annotated, get_origin, get_args, get_type_hints, Any  # noqa F401
+
+if sys.version_info >= (3,14):
+    import annotationlib
+    def get_annotations(cls: Any) -> dict[str, Any]:
+        return annotationlib.get_annotations(cls)
+elif sys.version_info >= (3, 10):
+    import inspect
+    def get_annotations(cls: Any) -> dict[str, Any]:
+        return inspect.get_annotations(cls)
+else:
+    def get_annotations(cls: Any) -> dict[str, Any]:
+        if isinstance(cls, type):
+            return cls.__dict__.get('__annotations__', {})
+        else:
+            return getattr(cls, '__annotations__', {})


 __all__ = ["Annotated", "get_origin", "get_args", "get_type_hints"]
diff --git a/cyclonedds/idl/_type_normalize.py b/cyclonedds/idl/_type_normalize.py
index 14c4c932..c0bb1d41 100644
--- a/cyclonedds/idl/_type_normalize.py
+++ b/cyclonedds/idl/_type_normalize.py
@@ -13,7 +13,7 @@
 from typing import Any, Dict, Union, ForwardRef
 from importlib import import_module
 
-from ._type_helper import Annotated, get_origin, get_args
+from ._type_helper import Annotated, get_origin, get_args, get_annotations
 from .types import array, sequence, typedef, case, default, NoneType
 
 
@@ -80,7 +80,9 @@ def _strip_unextended_type(module, _type: Any) -> Any:
 
 
 def _make_extended_type_hints(cls: Any) -> Dict[str, Any]:
-    hints = cls.__annotations__
+    hints = {}
+    for base in reversed(cls.__mro__):
+        hints.update(get_annotations(base))
     return {k: _strip_unextended_type(cls.__module__, v) for k, v in hints.items() if not k.startswith("__")}
 
 
diff --git a/cyclonedds/idl/annotations.py b/cyclonedds/idl/annotations.py
index d75822cc..7922bca3 100644
--- a/cyclonedds/idl/annotations.py
+++ b/cyclonedds/idl/annotations.py
@@ -33,9 +33,6 @@ def __field_annotate(pfield: str, annotation: str, value: Any) -> None:
     if not IDLNamespaceScope.current:
         raise TypeError("Cannot annotate fields while not in class scope")

-    if pfield not in IDLNamespaceScope.current["__annotations__"]:
-        raise TypeError(f"Member {pfield} is not defined.")
-
     if pfield not in IDLNamespaceScope.current["__idl_field_annotations__"]:
         IDLNamespaceScope.current["__idl_field_annotations__"][pfield] = {}

