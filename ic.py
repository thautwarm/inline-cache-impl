# -*- coding: utf-8 -*-
"""
Created on Tue Dec  1 18:15:38 2020

@author: twshe
"""

import bytecode as bc
import types
from pyximport import install
install()
import pic


def ic_opt(c: types.CodeType) -> types.CodeType:
    load_meth_later_bound = []
    def ic_bytecode(instrs):
        out = []
        for each in instrs:
            if isinstance(each, bc.Instr):
                if each.name == "LOAD_METHOD":
                    load_meth_later_bound.append((len(out), each.arg))
                    out.append(
                        bc.Instr("LOAD_CONST", None, lineno=each.lineno)
                    )
                    out.append(
                        bc.Instr("ROT_TWO", lineno=each.lineno)
                    )
                    continue
                elif each.name == "CALL_METHOD":
                    out.append(
                        bc.Instr("CALL_FUNCTION", each.arg + 1, lineno=each.lineno)
                    )
                    offset, attr = load_meth_later_bound.pop()
                    rec = getattr(pic, 'MonoICRec{}'.format(each.arg))(attr)
                    out[offset].arg = rec
                    continue
            out.append(each)
        return out
    c = bc.Bytecode.from_code(c)
    xs = ic_bytecode(c)
    c.clear()
    c.extend(xs)
    return c.to_code()
    
def ic(f):
    if not isinstance(f, types.FunctionType):
        raise TypeError(f)
    
    f.__code__ = ic_opt(f.__code__)
    return f




class K:
    def method(self, a):
        return 

def f(x):
    return x


class Sup2:
    @property
    def method(self):
        return f

class Sup1(Sup2):
    pass

class S(Sup1):
    def __getattribute__(self, attr):
        return object.__getattribute__(self, attr)

s = S()



@ic
def app1(x):
    for i in range(x):
        s.method(x)
    
def app2(x):
    for i in range(x):
        s.method(x)
    

from timeit import timeit
print(timeit("app(5)", globals=dict(app=app1)))
print(timeit("app(5)", globals=dict(app=app2)))
