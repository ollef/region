# region

Eventually, this might turn into an elaborator into the language defined by the
following typing relation.

Legend:
```
in-regions | environment |- term : type -| out-regions
```

`in-regions` is the set of regions that are alive _before_ evaluating `term`,
and `out-regions` are the set of regions that are alive _after_.  Note that
most rules have no `out-regions`, meaning that they deallocate all their
in-regions. The idea then is to use the `keep` and `frame` rules to keep
regions alive as long as they are needed (but no longer).

```

      x : a ϵ Γ
--------------------- var
{} | Γ |- x : a -| {}


    rs | Γ, x : a |- e : b -| {}
------------------------------------ lambda
{f} | Γ |- \x. e : a -f.rs-> b -| {}


rs1 | Γ |- e1 : (x : a) -f.frs-> b | rs2    rs2 | Γ |- e2 : a -| frs U {f}
-------------------------------------------------------------------------- app
                  rs1 | Γ |- e1 e2 : b -| {}


rs1 | Γ |- e1 : a -| rs2    rs2 | Γ, x : a |- e2 : b -| {}
---------------------------------------------------------- let
        rs1 | Γ |- let x = e1 in e2 : b -| {}


  rs | Γ, r : Region |- e : a -| {}
------------------------------------ letregion
rs | Γ |- letregion r in e : a -| {}


r : Region ϵ Γ    rs | Γ |- e : a -| {r}
---------------------------------------- box
   rs | Γ |- box r e : Box r a -| {}


r : Region ϵ Γ    rs | Γ |- e : Box r a -| {r}
---------------------------------------------- unbox
        rs | Γ |- unbox r e : a -| {}


      rs1 U {r} | Γ |- e : a -| rs2
------------------------------------------- keep r
rs1 U {r} | Γ |- keep r e : a -| rs2 U+ {r}


      rs1 | Γ |- e : a -| rs2
----------------------------------- frame rs
rs1 U+ rs | Γ |- e : a -| rs2 U+ rs

```
