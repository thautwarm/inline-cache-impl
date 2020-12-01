# -*- coding: utf-8 -*-
import string
header = """
from libc cimport stdint
from cpython cimport PyObject
import types
cdef extern from "Python.h":
    \"\"\"
#include <stdint.h>
static inline uint64_t addr_for_ic(PyObject* o){
    return (uint64_t) o;
}

#define py_type_for_ic(o) ((uint64_t) (((PyObject*)(o))->ob_type))
    \"\"\"
    stdint.uint64_t py_type_for_ic(object)
    stdint.uint64_t addr_for_ic(object)
    void PyErr_SetObject(object, object)
    object PyObject_GetAttr(object, object)

cdef stdint.uint64_t addr_staticmethod = addr_for_ic(staticmethod)
cdef stdint.uint64_t addr_classmethod = addr_for_ic(classmethod)
cdef stdint.uint64_t addr_property = addr_for_ic(property)
cdef object _unset = object()
"""
template = """
cdef inline object callrec$n(MonoICRec$n self, subject, $args):
    cdef:
        stdint.int8_t kind
        stdint.uint64_t tid
        stdint.uint64_t meth_tid
        type cls
        tuple mro

    
    tid = <stdint.uint64_t>(py_type_for_ic(subject))
    
    if self.tid == tid:
        kind = self.kind
        cache = self.cache
        if kind == 0: # object method
            return cache(subject, $args)
        elif kind == 1: # class method
            return cache(type(subject), $args)
        elif kind == 2: # static method
            return cache($args)
        elif kind == 3: # property
            return cache(subject)($args)
        else:
            # PyErr_SetObject(TypeError, "unknown cached method kind {}.".format(kind))
            # return do_except()
            pass
            

    cls = type(subject)
    cache = getattr(cls, self.attr, _unset)
    if cache is _unset:
        return PyObject_GetAttr(subject, self.attr)

    # start caching

    self.tid = tid
    o = _unset
    mro = cls.__mro__ 

    for t in mro:
        o = t.__dict__.get(self.attr, _unset)
        if o is _unset:
            continue
        break

    # assert o is not _unset
    meth_tid = py_type_for_ic(o)
    
    if meth_tid == addr_classmethod:
        cache = o.__func__
        self.cache = cache
        self.kind = 1
        return cache(cls, $args)
    elif meth_tid == addr_staticmethod:
        self.cache = cache
        self.kind = 2
        return cache($args)
    elif meth_tid == addr_property:
        cache = o.fget
        self.cache = cache
        self.kind = 3
        return cache(subject)($args)
    else:
        self.cache = cache
        self.kind = 0
        return cache(subject, $args)


cdef class MonoICRec$n:
    cdef:
        stdint.uint64_t tid
        stdint.int8_t kind # 0: self 1: class 2: static
        str attr
        object cache
        
    def describe(self):
        return self.kind, self.cache

    def __cinit__(self, str attr):
        self.cache = None
        self.attr = attr
        self.kind = 0
        self.tid = 0
    
    def __call__(self, subject, $args):
        return callrec$n(self, subject, $args)
    def __repr__(self):
        return "<MonoIC$n {} at {}>".format(self.attr, id(self))
"""

template = string.Template(template)


with open("pic.pyx", "w") as f:
    f.write(header)
    for n in range(5):
        args = ', '.join([f'a{i}' for i in range(n)])
        f.write(template.substitute(n=str(n), args=args))