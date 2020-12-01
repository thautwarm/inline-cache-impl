
from libc cimport stdint
from cpython cimport PyObject
import types
cdef extern from "Python.h":
    """
#include <stdint.h>
static inline uint64_t addr_for_ic(PyObject* o){
    return (uint64_t) o;
}

#define py_type_for_ic(o) ((uint64_t) (((PyObject*)(o))->ob_type))
    """
    stdint.uint64_t py_type_for_ic(object)
    stdint.uint64_t addr_for_ic(object)
    void PyErr_SetObject(object, object)
    object PyObject_GetAttr(object, object)

cdef stdint.uint64_t addr_staticmethod = addr_for_ic(staticmethod)
cdef stdint.uint64_t addr_classmethod = addr_for_ic(classmethod)
cdef stdint.uint64_t addr_property = addr_for_ic(property)
cdef object _unset = object()

cdef inline object callrec0(MonoICRec0 self, subject, ):
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
            return cache(subject, )
        elif kind == 1: # class method
            return cache(type(subject), )
        elif kind == 2: # static method
            return cache()
        elif kind == 3: # property
            return cache(subject)()
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
        return cache(cls, )
    elif meth_tid == addr_staticmethod:
        self.cache = cache
        self.kind = 2
        return cache()
    elif meth_tid == addr_property:
        cache = o.fget
        self.cache = cache
        self.kind = 3
        return cache(subject)()
    else:
        self.cache = cache
        self.kind = 0
        return cache(subject, )


cdef class MonoICRec0:
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
    
    def __call__(self, subject, ):
        return callrec0(self, subject, )
    def __repr__(self):
        return "<MonoIC0 {} at {}>".format(self.attr, id(self))

cdef inline object callrec1(MonoICRec1 self, subject, a0):
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
            return cache(subject, a0)
        elif kind == 1: # class method
            return cache(type(subject), a0)
        elif kind == 2: # static method
            return cache(a0)
        elif kind == 3: # property
            return cache(subject)(a0)
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
        return cache(cls, a0)
    elif meth_tid == addr_staticmethod:
        self.cache = cache
        self.kind = 2
        return cache(a0)
    elif meth_tid == addr_property:
        cache = o.fget
        self.cache = cache
        self.kind = 3
        return cache(subject)(a0)
    else:
        self.cache = cache
        self.kind = 0
        return cache(subject, a0)


cdef class MonoICRec1:
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
    
    def __call__(self, subject, a0):
        return callrec1(self, subject, a0)
    def __repr__(self):
        return "<MonoIC1 {} at {}>".format(self.attr, id(self))

cdef inline object callrec2(MonoICRec2 self, subject, a0, a1):
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
            return cache(subject, a0, a1)
        elif kind == 1: # class method
            return cache(type(subject), a0, a1)
        elif kind == 2: # static method
            return cache(a0, a1)
        elif kind == 3: # property
            return cache(subject)(a0, a1)
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
        return cache(cls, a0, a1)
    elif meth_tid == addr_staticmethod:
        self.cache = cache
        self.kind = 2
        return cache(a0, a1)
    elif meth_tid == addr_property:
        cache = o.fget
        self.cache = cache
        self.kind = 3
        return cache(subject)(a0, a1)
    else:
        self.cache = cache
        self.kind = 0
        return cache(subject, a0, a1)


cdef class MonoICRec2:
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
    
    def __call__(self, subject, a0, a1):
        return callrec2(self, subject, a0, a1)
    def __repr__(self):
        return "<MonoIC2 {} at {}>".format(self.attr, id(self))

cdef inline object callrec3(MonoICRec3 self, subject, a0, a1, a2):
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
            return cache(subject, a0, a1, a2)
        elif kind == 1: # class method
            return cache(type(subject), a0, a1, a2)
        elif kind == 2: # static method
            return cache(a0, a1, a2)
        elif kind == 3: # property
            return cache(subject)(a0, a1, a2)
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
        return cache(cls, a0, a1, a2)
    elif meth_tid == addr_staticmethod:
        self.cache = cache
        self.kind = 2
        return cache(a0, a1, a2)
    elif meth_tid == addr_property:
        cache = o.fget
        self.cache = cache
        self.kind = 3
        return cache(subject)(a0, a1, a2)
    else:
        self.cache = cache
        self.kind = 0
        return cache(subject, a0, a1, a2)


cdef class MonoICRec3:
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
    
    def __call__(self, subject, a0, a1, a2):
        return callrec3(self, subject, a0, a1, a2)
    def __repr__(self):
        return "<MonoIC3 {} at {}>".format(self.attr, id(self))

cdef inline object callrec4(MonoICRec4 self, subject, a0, a1, a2, a3):
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
            return cache(subject, a0, a1, a2, a3)
        elif kind == 1: # class method
            return cache(type(subject), a0, a1, a2, a3)
        elif kind == 2: # static method
            return cache(a0, a1, a2, a3)
        elif kind == 3: # property
            return cache(subject)(a0, a1, a2, a3)
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
        return cache(cls, a0, a1, a2, a3)
    elif meth_tid == addr_staticmethod:
        self.cache = cache
        self.kind = 2
        return cache(a0, a1, a2, a3)
    elif meth_tid == addr_property:
        cache = o.fget
        self.cache = cache
        self.kind = 3
        return cache(subject)(a0, a1, a2, a3)
    else:
        self.cache = cache
        self.kind = 0
        return cache(subject, a0, a1, a2, a3)


cdef class MonoICRec4:
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
    
    def __call__(self, subject, a0, a1, a2, a3):
        return callrec4(self, subject, a0, a1, a2, a3)
    def __repr__(self):
        return "<MonoIC4 {} at {}>".format(self.attr, id(self))
